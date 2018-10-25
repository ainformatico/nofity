//= require './note'

@App.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  URL_CATEGORIES = '/categories'

  class Entities.Category extends Entities.Model
    urlRoot: URL_CATEGORIES

  class Entities.Categories extends Entities.Collection
    url: URL_CATEGORIES

  class Entities.NotesInCategory extends Entities.Notes
    initialize: (models, options)->
      @options = options || {}

    url: ->
      url = URL_CATEGORIES
      if @options.id
        url = "#{url}/#{@options.id}"
      url

  App.reqres.setHandler 'entity:category', (options) ->
    new Entities.Category options || {}

  App.reqres.setHandler 'entities:category', (options) ->
    categories = new Entities.Categories options || {}
    categories.fetch()
    categories

  App.reqres.setHandler 'entities:note:category', (id) ->
    notes = new Entities.NotesInCategory [], id: id
    notes.fetch()
    notes
