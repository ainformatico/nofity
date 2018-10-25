#= require ./list_views

@App.module 'CategoriesApp.List', (List) ->

  class List.Controller extends App.Entities.Controller
    list: ->
      @categories = App.request 'entities:category'
      @when @categories, ->
        @showCategories()

    notesInCategory: (id) ->
      notes = App.request 'entities:note:category', id
      @when notes, ->
        App.execute 'app:notes:list:category', notes

    showCategories: ->
      categories = App.request 'entities:category'
      categoriesView = new List.Views.CategoriesViewDrag {
        collection: categories
      }
      categoriesView
