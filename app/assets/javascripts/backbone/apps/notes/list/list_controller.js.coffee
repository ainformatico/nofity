#= require ./list_views

@App.module 'NotesApp.List', (List, App) ->

  # TODO: temporary fix for saving only one instance of the view.
  #       the problem is that we are creating multiple instances of
  #       the controller and the event 'new:note' is being attached
  #       multiple times, and it's triggered after the view
  #       has been destroy
  tempView = null

  class List.Controller extends App.Entities.Controller
    layout: List.Views.Layout

    initialize: ->
      @listenTo App, 'new:note', @addNote

    addNote: (model) ->
      @notes.add(model, {at: 0, silent: true})
      tempView.render()

    list: ->
      @notes = App.request 'entities:note'
      @when @notes, ->
        @showNotes()

    publicNotes: ->
      @notes = App.request 'entities:note:public'
      @when @notes, ->
        @showPublicNotes()

    showPublicNotes: ->
      publicNotesView = new List.Views.NotesView(collection: @notes)
      App.execute('show:main', @layout)
      @showMainView()
      @showMain publicNotesView

    showNotes: (settings = {}) ->
      options = {
        collection: settings.notes || @notes
      }
      _.extend(options, settings)
      notesView = new List.Views.NotesView options
      App.execute('show:main', @layout)
      @showMainView()
      @showMain notesView

    showList: (notes) ->
      @notes = notes || App.request 'entities:note:static'
      tempView = new List.Views.NotesViewDroppable {
        collection: @notes
        filterInput: false
        noEmptyView: true
      }
      tempView

    viewNote: (id) ->
      note = App.request 'entity:note', {
        id: id
      }

      note.fetch()

      @when note, ->
        @showNote(note)

    showNote: (note) ->
      notes = new App.Entities.Notes(note)
      notesView = @showNotes(collection: notes, filterInput: false)
