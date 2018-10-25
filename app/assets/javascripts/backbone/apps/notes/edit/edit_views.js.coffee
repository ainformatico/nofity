@App.module 'NotesApp.Edit.Views', (Views, App) ->

  class Views.Layout extends App.Views.Layout
    template: 'note/shared/layout'
    regions: {
      mainRegion: '.main-region'
    }

  class Views.NoteEditView extends App.Views.FormView
    template: 'note/edit/note'

    triggers: {
      'click .js-cancel': 'cancel'
      'click .js-delete': 'remove'
    }

    events: {
      'click .link': 'onLink'
    }

    onSubmit: ->
      @model.update({
        success: =>
          @goBack()
      })
      App.track.save('note', 'edit')

    onCancel: ->
      @goBack()

    goBack: ->
      App.execute 'navigate', '/note'
      App.track.click('cancel', 'edit note')

    onRemove: ->
      @model.destroy()
      @onCancel()
      App.track.destroy('note', 'button')

    onLink: (e) ->
      App.track.click('edit', e.target.href)
