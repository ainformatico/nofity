describe 'App.track', ->

  it 'tracks defined actions', ->
    for action in ['type', 'click', 'save', 'new', 'destroy', 'edit', 'view', 'copy', 'search']
      expect(App.track[action]('category', 'label'))
        .toEqual(['send', 'event', 'category', action, 'label'])

  it 'assigns a defined value for the label', ->
    for value in [true, false]
      expect(App.track.edit('category', 'label', value))
        .toEqual(['send', 'event', 'category', 'edit', 'label', +value])

  it 'tracks pageview', ->
    expect(App.track.page())
      .toEqual(['send', 'pageview'])

  it 'tracks a custom action', ->
    expect(App.track.event('action', 'category', 'label'))
      .toEqual(['send', 'event', 'category', 'action', 'label'])

  it 'sets a custom value', ->
    expect(App.track.set('custom', 'value'))
      .toEqual(['set', 'custom', 'value'])

  it 'sets registers a user', ->
    expect(App.track.registerUser('1234'))
      .toEqual(['set', 'userId', '1234'])
