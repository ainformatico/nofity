@App.module 'log', (log, App) ->

  _convertToArray = (obj) ->
    Array.prototype.slice.call(obj, 0)

  _handler = (args) ->
    if App.config?.isDev and typeof window.console == 'object'
      args = _convertToArray(args)
      console.log.apply(console, args)

  API = {
    info: ->
      _handler(arguments)

  }

  _.extend(@, API)
