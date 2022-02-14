class LocalitiesController < ApplicationController
  def index
    if params[:latitude].blank? || params[:longitude].blank?
      render json: { error: "Required parameters: latitude, longitude" }, status: :not_acceptable
    else
      render json: Locality.best_matches_by_location(params[:latitude], params[:longitude]).limit(1).first
    end
  end
end
