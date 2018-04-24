module Api::V1
  class ApiController < ApplicationController
    ERROR_SERIALIZER = ActiveModel::Serializer::ErrorSerializer

    def render_error_json(error_msg, status = :not_found)
      resource = NullResource.new
      resource.errors.add(status, error_msg)

      render json: resource,
             status: status, serializer: ERROR_SERIALIZER
    end

    def json_response(resource, status = :ok, included = [])
      render json: resource, include: included, status: status
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      render_error_json "Could not find #{e.model.downcase} with id #{e.id}"
    end
  end
end