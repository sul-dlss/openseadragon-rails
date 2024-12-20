require 'rails/generators'

module Openseadragon
  class Install < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def append_javascript
      run "yarn init -y"
      gsub_file "package.json", /\.internal_test_app/, "internal_test_app" # name beginning with a dot is illegal
      run "yarn add openseadragon-rails"

      append_to_file 'app/javascript/application.js' do
        <<~CONTENT

          import "openseadragon-rails"

        CONTENT
      end
    end

    def append_image_paths
      append_to_file 'config/initializers/assets.rb' do
        "\nRails.application.config.assets.paths << Rails.root.join('node_modules/openseadragon/build/openseadragon/images')\n"
      end
    end

    def inject_helper
      inject_into_class 'app/controllers/application_controller.rb', ApplicationController do
        "  helper Openseadragon::OpenseadragonHelper\n"
      end
    end
  end
end
