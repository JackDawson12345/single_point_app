# config/initializers/session_store.rb
Rails.application.config.session_store :cookie_store,
                                       key: '_single_point_app_session',
                                       domain: :all  # This allows session sharing across subdomains