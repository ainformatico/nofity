@App.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  current_user = null

  class Entities.User extends Entities.Model
    urlRoot: '/user'

  App.reqres.setHandler 'entity:current:user', ->
    if current_user
      current_user
    else
      user = new Entities.User
      current_user = user
      user.fetch()
      user
