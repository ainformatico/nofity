@App.module 'NotesApp.List.Views', (Views, App) ->

  CATEGORIES_SERVER_PATH = '/categories/'

  class Views.Layout extends App.Views.Layout
    template: 'note/shared/layout'
    regions: {
      mainRegion: '.main-region'
    }

  class Views.NoteEmptyView extends App.Views.EmptyView
    template: 'note/empty'

  class Views.NoteView extends App.Views.ItemView
    template: 'note/note'

    modelEvents: {
      'change': 'render'
    }

    ui : {
      inputElement: 'input[type=checkbox]'
    }

    triggers: {
      'click .js-delete': 'remove'
      'click .js-edit': 'edit'
      'click .js-view': 'view'
      'click .js-copy': 'copy'
    }

    events: {
      'click .note-title a.link': 'onLinkNavigation'
      'click .js-visibility': 'onVisibility'
      'click .note-description a.link': 'onCategoryLink'
    }

    serializeData: ->
      data = super
      data.isOwner = App.request('validate', @model)
      data

    onLinkNavigation: (e) ->
      App.track.click('note', e.target.href)

    onCategoryLink: (e) ->
      e.preventDefault()
      uri = e.target.pathname
      App.execute 'navigate', uri
      App.track.click('note', uri)

    initialize: ->
      @listenTo @, 'render', @checkData

    onView: ->
      App.execute 'app:notes:view', @model
      App.track.view('note', 'button')

    onEdit: ->
      App.execute 'navigate', "#{@model.url()}/edit"
      App.track.edit('note', 'button')

    onCopy: ->
      App.track.copy('note', 'button')
      @model.copyToCurrentUser()

    onVisibility: ->
      stat = @ui.inputElement.is(':checked')
      @model.set('public', stat)
      @model.update()
      App.track.edit('note', 'visibility', stat)

    onRemove: ->
      @model.destroy()
      App.track.destroy('note', 'button')

    onRender: ->
      text = @model.get('content')
      categories = @model.get('categories')
      newText = @linkCategories(text, categories)
      newText = @linkUrls(newText)
      @$('.note-description').html(newText)

    onDestroy: ->
      @model.clearTimeout()

    checkData: ->
      @model.checkData()

    linkCategories: (text, categories) ->
      twttr.txt.autoLinkHashtags(twttr.txt.htmlEscape(text), {
        hashtagClass: 'link'
        suppressNoFollow: true
        linkAttributeBlock: (entity, attrs) ->
          category = _.find categories, (cat) ->
            cat.name == entity.hashtag
          if category
            attrs.href = "#{CATEGORIES_SERVER_PATH}#{category.id}"
          else
            # FIXME: in case the category does not exist
            #        but it's applied,
            #        it will add Twitter's url searching for
            #        the hashtash.
            attrs.href = '/'
          attrs.href
      })

    linkUrls: (text) ->
      twttr.txt.autoLinkUrlsCustom(text, {
        linkTextBlock: (entity, text) ->
          dust.filters.urlTrim(text)
      })

  class Views.NoteViewDroppable extends Views.NoteView
    onDomRefresh: ->
      $('.note').droppable {
        hoverClass: 'ui-state-hover'
        accept: ':not(.ui-sortable-helper)'
        drop: @onDrop
      }

    onDrop: (e, ui) =>
      category = App.request 'app:memory:get', 'category:dragging', true
      @model.addCategory(category)
      @model.save()

  class Views.NotesView extends App.Views.CompositeView
    template: 'note/notes_list'
    childView: Views.NoteView
    emptyView: Views.NoteEmptyView
    childViewContainer: '.list'

    ui: {
      searchElement: '.search'
    }

    options: {
      filterInput: true
    }

    events: {
      'keyup @ui.searchElement': 'onSearch'
      'keydown @ui.searchElement': 'onPress'
    }

    initialize: ->
      @listenToOnce @, 'search:keydown', @track
      if @options.noEmptyView
        @emptyView = null

    onDomRefresh: ->
      @ui.searchElement.focus()

    onSearch: (e) ->
      @filter($(e.target).val())

    onPress: ->
      @trigger('search:keydown')

    serializeData: ->
      data = super
      data.filterInput = @options.filterInput
      data

    filter: (term) ->
      notes = @$('div.list > div')
      if _.str.trim(term).length
        _.each notes, (note) ->
          note = $(note)
          text = note.find('h2, p').text()
          pattern = new RegExp(term, 'gi')
          if pattern.test(text)
            method = 'show'
          else
            method = 'hide'

          note[method]()
      else
        notes.show()

    track: ->
      App.track.search('note', 'filter')

  class Views.NotesViewDroppable extends Views.NotesView
    childView: Views.NoteViewDroppable
