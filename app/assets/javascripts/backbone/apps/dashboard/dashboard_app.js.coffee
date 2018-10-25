@App.module 'DashboardApp', (DashboardApp, App) ->

  API = {
    init: ->
      new DashboardApp.Controller
  }

  class DashboardApp.Router extends App.Entities.Router
    appRoutes: {
      'dashboard' : 'init'
    }
    controller: API

  App.addInitializer ->
    new DashboardApp.Router

  App.commands.setHandler 'navigate:dashboard', ->
    App.execute 'navigate', '/dashboard'
