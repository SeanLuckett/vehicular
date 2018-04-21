module Api::V1
  class ApiController < ApplicationController
    ERROR_SERIALIZER = ActiveModel::Serializer::ErrorSerializer

    def render_error_json(resource_klass)
      missing_resource = resource_klass.new
      missing_resource.errors.add(:not_found,
                                  "Could not find #{resource_klass.name.downcase} with that id")
      render json: missing_resource,
             status: :not_found, serializer: ERROR_SERIALIZER
    end
  end
end