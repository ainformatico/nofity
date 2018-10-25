Haml::Template.options[:attr_wrapper] = '"'

# Allow Haml assets in the asset pipeline.
Rails.application.assets.register_engine('.haml', Tilt::HamlTemplate)
