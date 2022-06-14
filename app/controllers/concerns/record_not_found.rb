module RecordNotFound
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |ex|
      render json: { status: 404, error: ex.to_s }, status: 404
    end
  end
end
