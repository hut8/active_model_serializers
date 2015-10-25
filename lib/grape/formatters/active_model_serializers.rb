# A grape response formatter that can be used as 'formatter :json, Grape::Formatters::ActiveModelSerializers'
#
# Serializer options can be passed as a hash from your grape endpoint using env[:active_model_serializer_options],
# or better yet user the render helper in Grape::Helpers::ActiveModelSerializers
module Grape
  module Formatters
    module ActiveModelSerializers
      RequestContext = Struct.new(:original_url, :query_parameters)

      class << self
        def call(resource, env)
          serializer_options = {}
          serializer_options.merge!(env[:active_model_serializer_options]) if env[:active_model_serializer_options]

          serializer_options[:context] = RequestContext.new(env['REQUEST_URI'],
                                                            env['rack.request.query_hash'])
          ActiveModel::SerializableResource.new(resource, serializer_options).to_json(serializer_options)
        end
      end
    end
  end
end
