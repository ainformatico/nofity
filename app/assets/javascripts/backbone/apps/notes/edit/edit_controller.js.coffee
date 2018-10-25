#= require ./edit_views

@App.module 'NotesApp.Edit', (Edit) ->

  class Edit.Controller extends App.Entities.Controller
    layout: Edit.Views.Layout

    edit: (id) ->
      note = App.request 'entity:note', {
        id: id
      }

      note.fetch()
      @when note, ->
        if App.request('validate', note, true)
          @showEditNote(note)

    showEditNote: (note) ->
      noteView = new Edit.Views.NoteEditView {
        model: note
      }

      @showMainView()
      @showMain noteView
