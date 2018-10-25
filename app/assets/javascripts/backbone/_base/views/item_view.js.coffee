@App.module 'Views', (Views, App, Backbone, Marionette, $, _) ->

  class Views.ItemView extends Marionette.ItemView

    onLinkNavigation: (e) ->
      e.preventDefault() if e

      href = $(e.target).attr('href')
      App.execute 'navigate', href
