#= require ../item_view

@App.module 'Views.Form', (Form, App, Backbone, Marionette, $, _) ->

  class Form.EnterKey extends App.Views.ItemView
    ui :{
      inputElement: 'input.js-enter'
    }

    autoFocus: true

    events: {
      'keydown @ui.inputElement' : '_onKeyDown'
    }

    initialize: ->
      if @autoFocus
        @listenTo @, 'dom:refresh', @focusInputElement

    focusInputElement: ->
      @ui.inputElement.focus()

    _onKeyDown: (e) ->
      if e.keyCode == 13
        e.preventDefault()
        value = @ui.inputElement.val()
        @onEnterKey.apply @, [e, value]
