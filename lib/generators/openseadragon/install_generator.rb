require 'rails/generators'

module Openseadragon
  class Install < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def append_javascript
      run 'yarn init -y'
      gsub_file 'package.json', /\.internal_test_app/, 'internal_test_app' # name beginning with a dot is illegal
      run 'yarn add openseadragon-rails'

      run 'bin/importmap pin openseadragon' if File.exist?('bin/importmap')

      append_to_file 'app/javascript/application.js' do
        <<~CONTENT

          import "openseadragon"
          import "openseadragon-rails"

        CONTENT
      end
    end

    def append_image_paths
      append_to_file 'config/initializers/assets.rb' do
        "\nRails.application.config.assets.paths << Rails.root.join('node_modules/openseadragon/build/openseadragon/images')\n"
      end
    end

    def add_default_style
      copy_file 'openseadragon.css', 'app/assets/stylesheets/openseadragon.css'
  
      if (scss_file = %w[app/assets/stylesheets/application.bootstrap.scss
                         app/assets/stylesheets/application.scss].find { |f| File.exist?(f) })
        append_to_file scss_file, "\n@import 'openseadragon';\n"
      end
    end

    def inject_helper
      inject_into_class 'app/controllers/application_controller.rb', ApplicationController do
        "  helper Openseadragon::OpenseadragonHelper\n"
      end
    end
  end
end
