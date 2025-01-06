# frozen_string_literal: true

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
      app.config.assets.precompile += %w[
        button_grouphover.png flip_pressed.png home_grouphover.png next_pressed.png rotateleft_grouphover.png
        rotateright_pressed.png zoomout_grouphover.png button_hover.png flip_rest.png home_hover.png next_rest.png
        rotateleft_hover.png rotateright_rest.png zoomout_hover.png button_pressed.png fullpage_grouphover.png
        home_pressed.png previous_grouphover.png rotateleft_pressed.png zoomin_grouphover.png zoomout_pressed.png
        button_rest.png fullpage_hover.png home_rest.png previous_hover.png rotateleft_rest.png zoomin_hover.png
        zoomout_rest.png flip_grouphover.png fullpage_pressed.png next_grouphover.png previous_pressed.png
        rotateright_grouphover.png zoomin_pressed.png flip_hover.png fullpage_rest.png next_hover.png previous_rest.png
        rotateright_hover.png zoomin_rest.png
      ]
    end

    initializer 'openseadragon.importmap', before: 'importmap' do |app|
      app.config.assets.paths << Engine.root.join('app/javascript')
      app.config.importmap.paths << Engine.root.join('config/importmap.rb') if app.config.respond_to?(:importmap)
    end
  end
end
