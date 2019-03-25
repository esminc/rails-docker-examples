class VisitsController < ApplicationController
  def index
    Visit.create! visited_at: Time.current

    render json: Visit.order(visited_at: :desc)
  end
end
