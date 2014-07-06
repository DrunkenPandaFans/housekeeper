module API
  class CirclesController < ApplicationController
    def index
      circles = Circle.all
      name = params[:name]

      if name
        circles = circles.search(name)
      end

      render json: circles, status: 200, root: false
    end

    def show
      circle = Circle.find_by_id(params[:id])
      if circle
        render json: circle, status: 200, root: false
      else
        head 404
      end
    end

    def create
      circle = Circle.new(circle_params)
      if circle.save
        # location tries circle_url instead of prefixed version
        render json: circle, status: 201, location: api_circle_url(circle)
      else
        render json: circle.errors.full_messages, status: 422
      end
    end

    private
      
      def circle_params
        params.permit(:name, :description)
      end
  end
end
