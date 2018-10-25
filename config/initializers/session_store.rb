# Be sure to restart your server when you modify this file.
Rails.application.config.session_store :redis_store,
                                       redis_server: {
                                         db: 0,
                                         url: ENV.fetch('REDIS_URL'),
                                         namespace: 'nofity:sessions'
                                       }
