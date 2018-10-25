@App.module 'CategoriesApp.List.Views', (Views, App) ->

  class Views.Layout extends App.Views.Layout
    template: 'category/shared/layout'
    regions: {
      mainRegion: '.main-region'
    }

  class Views.CategoryView extends App.Views.ItemView
    template: 'category/category'

    triggers: {
      'click .js-delete': 'remove'
    }

    onRemove: ->
      @model.destroy()

  class Views.CategoryViewDrag extends Views.CategoryView
    onDomRefresh: ->
      @$('.label').draggable {
        helper: 'clone'
        start: @onStart
      }

    onStart: =>
      App.execute 'app:memory:save', 'category:dragging', @model


  class Views.CategoriesView extends App.Views.CompositeView
    template: 'category/categories'
    childView: Views.CategoryView
    childViewContainer: '.list'

  class Views.CategoriesViewDrag extends Views.CategoriesView
    childView: Views.CategoryViewDrag
    childViewContainer: '.list'
