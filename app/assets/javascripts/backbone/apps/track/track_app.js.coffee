@App.module 'track', (track, App) ->

  _analytics = (args) ->
    App.log.info(args)
    window.ga && window.ga.apply(window, args)
    args # returns what was sent, primary for testing purposes

  _setValues = (name, value) ->
    _analytics(['set', name, value])

  _handler = (category, label, action, value) ->
    if category and label
      # 'send', category, action, label, (value)?
      # ga('send', 'event', 'button', 'click', 'nav buttons', 4)
      data = ['send', 'event', category, action, label]
      unless value == undefined
        data.push(+value)

      _analytics(data)

  API = {
    page: ->
      _analytics(['send', 'pageview'])
    type: (category, label) ->
      _handler(category, label, 'type')
    click: (category, label) ->
      _handler(category, label, 'click')
    save: (category, label) ->
      _handler(category, label, 'save')
    new: (category, label) ->
      _handler(category, label, 'new')
    destroy: (category, label) ->
      _handler(category, label, 'destroy')
    edit: (category, label, value) ->
      _handler(category, label, 'edit', value)
    view: (category, label) ->
      _handler(category, label, 'view')
    copy: (category, label) ->
      _handler(category, label, 'copy')
    search: (category, label) ->
      _handler(category, label, 'search')
    event: (action, category, label) ->
      _handler(category, label, action)
    set: (name, value) ->
      _setValues(name, value)
    registerUser: (uid) ->
      _setValues('userId', uid)
  }

  _.extend(@, API)
