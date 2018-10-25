@App.module 'Views', (Views, App, Backbone, Marionette, $, _) ->

  class Views.FormView extends Marionette.ItemView

    _triggers: {
      'submit form': 'form:submit'
    }

    constructor: (model) ->
      @_extendTriggers()
      super(model)

    _extendTriggers: ->
      @triggers = _.extend({}, @_triggers, @triggers)

    onFormSubmit: ->
      @serializeWithSyphon()
      @onSubmit() if @onSubmit

    serializeWithSyphon: ->
      data = Backbone.Syphon.serialize @
      @model.set(data)
