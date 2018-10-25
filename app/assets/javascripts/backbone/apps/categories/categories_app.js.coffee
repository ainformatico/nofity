@App.module 'CategoriesApp', (CategoriesApp, App) ->

  API = {
    list: ->
      controller = new CategoriesApp.List.Controller
      controller.showCategories()

    listNotes: (id) ->
      controller = new CategoriesApp.List.Controller
      controller.notesInCategory(id)
  }

  class CategoriesApp.Router extends App.Entities.Router
    appRoutes: {
      'categories/:id' : 'listNotes'
    }
    controller: API

  App.reqres.setHandler 'app:categories:list:view', ->
    API.list()

  App.addInitializer ->
    new CategoriesApp.Router
