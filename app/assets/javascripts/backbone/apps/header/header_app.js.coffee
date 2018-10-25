#= require_tree ./views

@App.module 'HeaderApp', (HeaderApp, App) ->

  App.addInitializer ->
    header = App.request 'get:header'

    view = new HeaderApp.Views.Layout {
      el: header.el
    }
