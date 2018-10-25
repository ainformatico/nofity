@App.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Controller extends Marionette.Controller
    constructor: (options, proto) ->
      @initLayout() if @layout
      super(options, proto)

    initLayout: ->
      @_showLayout()

    _showLayout: ->
      @layout = new @layout
      @listenTo @layout, 'destroy', @destroy

    showMainView: ->
      App.execute('show:main', @layout)

    showMain: (view) ->
      @layout.mainRegion.show view

    resolved: (callback) =>
      =>
        callback.apply @, arguments

    when: (entities, callback) ->
      xhrs = _.chain([entities]).flatten().pluck("_deferred").value()

      $.when.apply($, xhrs).done @resolved(callback)
