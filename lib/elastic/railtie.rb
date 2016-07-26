require "elastic/railties/utils"
require "elastic/railties/ar_helpers"
require "elastic/railties/ar_middleware"
require "elastic/railties/type_extensions"
require "elastic/railties/query_extensions"
require "elastic/railties/indexable_record"

module Elastic
  class Railtie < Rails::Railtie
    initializer "elastic.configure_rails_initialization" do
      Elastic.configure Rails.application.config_for(:elastic)

      # Make every activerecord model indexable
      ActiveRecord::Base.send(:include, Elastic::Railties::IndexableRecord)
    end

    rake_tasks do
      load File.expand_path('../railties/tasks/es.rake', __FILE__)
    end

    # TODO: configure generators here too
  end
end

# Expose railties utils at Elastic namespace
module Elastic
  extend Elastic::Railties::Utils
end

# Add activerecord related index helpers
class Elastic::Type
  include Elastic::Railties::TypeExtensions
end

# Add activerecord related query helpers
class Elastic::Query
  include Elastic::Railties::QueryExtensions
end

# Register active record middleware
Elastic.register_middleware Elastic::Railties::ARMiddleware
