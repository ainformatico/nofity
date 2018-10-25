@App.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Router extends Marionette.AppRouter
    onRoute: ->
      App.track.page()
