@App.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Model extends Backbone.Model

    constructor: (attributes, options) ->
      super attributes, options
      Entities.Deferred.call @

    update: (settings) ->
      options = _.extend(settings || {}, patch: true)
      @save(@changed, options)
