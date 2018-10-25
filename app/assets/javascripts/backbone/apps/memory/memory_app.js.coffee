@App.module 'MemoryApp', (MemoryApp, App) ->

  stack = {}

  App.commands.setHandler 'app:memory:save', (key, value) ->
    stack[key] = value

  App.reqres.setHandler 'app:memory:get', (key, remove) ->
    oldValue = stack[key]
    if remove
      delete stack[key]

    oldValue
