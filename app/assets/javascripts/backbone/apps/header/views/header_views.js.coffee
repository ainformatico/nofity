@App.module 'HeaderApp.Views', (Views, App) ->

  class Views.Layout extends App.Views.ItemView
    events: {
      'click a:not([data-bypass="true"])' : 'onLinkNavigation',
      'click .dropdown-menu a': 'onExternalNavigation',
      'click .dropdown-toggle': 'onOpenMenu'
    }

    onExternalNavigation: (e) ->
      @track(e.target.pathname)

    onOpenMenu: ->
      App.track.click('header', 'open profile menu')

    onLinkNavigation: (e) ->
      @track(e.target.pathname)
      super

    track: (url) ->
      App.track.click('header', url)
