#= require ./dashboard_view

@App.module 'DashboardApp', (DashboardApp, App) ->

  class DashboardApp.Controller extends App.Entities.Controller
    layout: DashboardApp.Views.Layout

    initialize: ->
      @showLayout()
      @showCategories()
      @showSearchBar()
      @showNotes()
      @showOnboarding()

    showOnboarding: ->
      if App.config.onboardings.initial
        App.execute 'onboarding:initial'

    showSearchBar: ->
      searchBar = @initSearchBar()
      @showMain searchBar

    showNotes: ->
      notesView = @initNotes()
      @layout.notesRegion.show notesView

    showCategories: ->
      if App.config.features.categories
        categoriesView = @initCategories()
        @layout.categoriesRegion.show categoriesView

    initSearchBar: ->
      new DashboardApp.Views.SearchBar

    showLayout: ->
      App.execute('show:main', @layout)

    initCategories: ->
      App.request 'app:categories:list:view'

    initNotes: ->
      App.request 'app:notes:list:view'
