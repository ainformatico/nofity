@App.module 'OnboardingApp', (OnboardingApp, App, Backbone, Marionette, $, _) ->

  createTour = (name, steps) ->
    translations = App.config.i18n.onboardings[name]

    if steps.length != translations.length
      throw new Error("translations don't match steps")

    steps = _.each steps, (step, index) ->
      step.title = translations[index].title
      step.content = translations[index].content

    opts = {
      name: name
      steps: steps
      storage: false
      onNext: ->
        App.track.event('onboarding', 'next', name)
      onPrev: ->
        App.track.event('onboarding', 'prev', name)
      onEnd: ->
        App.request 'entity:onboarding', (id: name)
        App.track.event('onboarding', 'end', name)
    }
    tour = new Tour(opts)

    tour.init()
    tour.start()
    App.track.event('onboarding', 'show', name)


  App.commands.setHandler 'onboarding:initial', ->

    createTour('initial', [
      {
        element: '#dashboard-submit',
        placement: 'right',
        onShow: ->
          element = $('#dashboard-input')
          element.val('https://nofity.com')
      },
      {
        element: '#notes-list',
        placement: 'bottom'
      },
      {
        element: '#notes-public',
        placement: 'bottom'
      },
      {
        element: '#user-profile',
        placement: 'bottom'
      }
    ])
