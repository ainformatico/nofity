_.extend dust.filters,
  urlTrim: (text) ->
    _.str.prune(text
      .replace(/https?:\/\/(www\.)?/, '')
      .replace(/\/$/, '')
    , 40)
