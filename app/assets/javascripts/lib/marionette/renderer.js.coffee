Backbone.Marionette.Renderer.render = (template, data) ->
  'use strict'

  output = ""

  dust.render template, data, (error, out) ->
    if error
      throw error
    output = out

  output
