@App.module 'NotesApp', (NotesApp, App) ->

  API = {
    init: ->
      controller = new NotesApp.List.Controller
      controller.list()
    edit: (id) ->
      controller = new NotesApp.Edit.Controller
      controller.edit(id)
    list: (notes) ->
      controller = new NotesApp.List.Controller
      controller.showList(notes)
    public: ->
      controller = new NotesApp.List.Controller
      controller.publicNotes()
    notesInCategory: (notes) ->
      controller = new NotesApp.List.Controller
      controller.showNotes(collection: notes)
    view: (note) ->
      controller = new NotesApp.List.Controller
      controller.viewNote(note)
  }

  class NotesApp.Router extends App.Entities.Router
    appRoutes: {
      'note' : 'init'
      'note/:id' : 'view'
      'note/:id/edit' : 'edit'
      'public' : 'public'
    }
    controller: API

  App.commands.setHandler 'app:notes:view', (model) ->
    App.execute 'navigate', model.url()

  App.reqres.setHandler 'app:notes:list:view', (notes) ->
    API.list(notes)

  App.commands.setHandler 'app:notes:list:category', (notes) ->
    API.notesInCategory(notes)

  App.addInitializer ->
    new NotesApp.Router
