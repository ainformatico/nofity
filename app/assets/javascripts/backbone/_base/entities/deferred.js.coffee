@App.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  initializeDeferred = ->
    @_deferred = $.Deferred()

    @listenTo @, 'sync', ->
      @_deferred.resolve()

    @listenTo @, 'error', (model, xhr, options) ->
      @_deferred.reject(model, xhr, options)

    # Alias deferred methods
    @done = @_deferred.done
    @fail = @_deferred.fail
    @then = @_deferred.then

    @isResolved = ->
      @_deferred.state() == "resolved"

    @isRejected = ->
      @_deferred.state() == "rejected"

  Entities.Deferred = ->
    initializeDeferred.call(@)

    oldFetch = @fetch
    @fetch = (options) ->
      initializeDeferred.call(@)
      oldFetch.call(@, options)
