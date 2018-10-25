@App = do(Backbone, Marionette, jQuery) ->

  USER = null

  app = new Marionette.Application

  app.addRegions {
    headerRegion: '#header-region'
    mainRegion: '#main-region'
    messagesRegion: '#messages-region'
  }

  app.on 'start', ->
    if Backbone.history
      Backbone.history.start
        pushState: true
        hashChange: true

  app.addInitializer ->
    # do not use 'real' PATCH, PUT and DELETe
    # this allows to use patch: true in non-facy
    # browsers, like capybara
    Backbone.emulateHTTP = true

  app.addInitializer ->
    # prevents showing raw json when clicking in the browser's
    # back button from a non-pushState page
    # https://github.com/jashkenas/backbone/issues/630
    jQuery.ajaxSetup({
      cache: false
    })

  app.addInitializer ->
    App.request 'entity:current:user'
    App.track.registerUser(App.config.uid)

  app.addInitializer ->
    # workaround for creating a view form existing html,
    # all the flash messages will be shown here
    messagesView = new App.Views.ItemView({
      el: $("#messages-region")
    })

    app.messagesRegion.attachView(messagesView)

  app.commands.setHandler 'show:main', (view) ->
    app.mainRegion.show view

  app.reqres.setHandler 'get:header', ->
    app.headerRegion

  app.commands.setHandler 'navigate', (url) ->
    # ensure the messagesRegion is destroyed on every navigation
    # so we don't display it for ever
    app.messagesRegion.currentView.destroy()
    Backbone.history.navigate url, trigger: true

  app.reqres.setHandler 'validate', (item, redirect = false) ->
    USER ||= app.request('entity:current:user')
    result = item.get('user') == USER.get('id')
    if !result and redirect
      app.execute 'navigate:dashboard'

    result

  app

$ =>
  @App.start()
