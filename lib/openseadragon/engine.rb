module Openseadragon
  class Engine < ::Rails::Engine
    isolate_namespace Openseadragon

    config.before_configuration do
      # see https://github.com/fxn/zeitwerk#for_gem
      # openseadragon_rails puts a generator into LOCAL APP lib/generators, so tell
      # zeitwerk to ignore the whole directory? If we're using a recent
      # enough version of Rails to have zeitwerk config
      #
      # See: https://github.com/cbeer/engine_cart/issues/117
      if Rails.try(:autoloaders).try(:main).respond_to?(:ignore)
        Rails.autoloaders.main.ignore(Rails.root.join('lib/generators'))
      end
    end

    initializer 'openseadragon.assets.precompile' do |app|
      app.config.assets.precompile += %w[node_modules/openseadragon/build/openseadragon/images/*.png]
    end

    initializer "openseadragon.importmap", before: "importmap" do |app|
      app.config.importmap.paths << Engine.root.join("config/importmap.rb") if app.config.respond_to?(:importmap)
    end
  end
end
