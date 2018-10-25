@App.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  URL_NOTES = '/note'
  URL_PUBLIC_NOTES = '/public'
  URL_COPY_NOTE = "#{URL_NOTES}/copy"
  MAX_REQUESTS_FOR_NEW_DATA = 5

  class Entities.Note extends Entities.Model
    urlRoot: URL_NOTES

    _current_request:  0

    initialize: ->
      @listenTo @, 'sync', @checkData

    addCategory: (category) ->
      categories = _.clone(@get('categories')) # due to backbone
      categories.push(category.toJSON())
      @set('categories', _.uniq(categories, (item) ->
        item.id
      ))

    checkData: ->
      link = @get('link')
      if link and !link.processed
        if @_current_request < MAX_REQUESTS_FOR_NEW_DATA
          @_current_request++
          @timeout = setTimeout =>
            @fetch()
          , @_current_request * 2000

    copyToCurrentUser: ->
      @save({id: @get('id')}, {patch: true, url: URL_COPY_NOTE})

    clearTimeout: ->
      clearTimeout(@timeout) if @timeout


  class Entities.Notes extends Entities.Collection
    model: Entities.Note
    url: URL_NOTES

    # override so we prevent inserting empty models
    add: (model) ->
      if model instanceof Entities.Note and model.get('id') != null
        super
      @

  class Entities.PublicNotes extends Entities.Notes
    url: URL_PUBLIC_NOTES

  API = {
    notes: (options) ->
      new Entities.Notes options
    publicNotes: ->
      new Entities.PublicNotes
  }

  App.reqres.setHandler 'entity:note', (options) ->
    new Entities.Note options

  App.reqres.setHandler 'entities:note:static', (options) ->
    API.notes(options)

  App.reqres.setHandler 'entities:note', (options) ->
    notes = API.notes(options)
    notes.fetch()
    notes

  App.reqres.setHandler 'entities:note:public', ->
    notes = API.publicNotes()
    notes.fetch()
    notes
