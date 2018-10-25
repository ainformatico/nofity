@App.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  URL_ONBOARDING = '/onboarding/'

  class Entities.Onboarding extends Entities.Model
    urlRoot: URL_ONBOARDING

  App.reqres.setHandler 'entity:onboarding', (options) ->
    onboarding = new Entities.Onboarding(options)
    onboarding.save()
    onboarding
