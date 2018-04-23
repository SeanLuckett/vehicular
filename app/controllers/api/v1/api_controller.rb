module Api::V1
  class ApiController < ApplicationController
    ERROR_SERIALIZER = ActiveModel::Serializer::ErrorSerializer

    def render_error_json(status, error_msg)
      resource = NullResource.new
      resource.errors.add(status, error_msg)

      render json: resource,
             status: status, serializer: ERROR_SERIALIZER
    end
  end
end