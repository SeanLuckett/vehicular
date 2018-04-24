module Api::V1
  class ApiController < ApplicationController
    ERROR_SERIALIZER = ActiveModel::Serializer::ErrorSerializer

    def error_json(resource, status = :unprocessable_entity)
      render json: resource,
             status: status, serializer: ERROR_SERIALIZER
    end

    def json_response(resource, status = :ok, included = [])
      render json: resource, include: included, status: status
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      resource = build_error_resource(e.model, "Could not find #{e.model.downcase} with id #{e.id}")
      error_json resource, :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      resource = build_error_resource(e.model, e.message)
      error_json resource
    end

    private

    def build_error_resource(model_name, msg)
      resource = model_name.constantize.new
      resource.errors.add(:record, msg)
      resource
    end
  end
end