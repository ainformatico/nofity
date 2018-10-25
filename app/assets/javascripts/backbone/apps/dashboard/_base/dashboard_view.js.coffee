@App.module 'DashboardApp.Views', (Views, App, Backbone, Marionette, $, _) ->

  class Views.Layout extends App.Views.Layout
    template: 'dashboard/layout'

    regions: {
      mainRegion: '.main-region'
      categoriesRegion: '.categories-region'
      notesRegion: '.notes-region'
    }

  class Views.SearchBar extends App.Views.Form.EnterKey
    template: 'dashboard/search'

    triggers: {
      'click .js-submit' : 'submit'
    }

    onSubmit: ->
      @createNote(@ui.inputElement.val())

    onEnterKey: (e, value) ->
      @createNote(value)

    createNote: (value) ->
      return if _.isEmpty(_.string.trim(value))

      options = {
        content: value
      }
      note = App.request('entity:note', options)
      note.save()
      @ui.inputElement.val('')

      App.trigger('new:note', note)
      @track()

    track: ->
      App.track.new('note', 'dashboard')
