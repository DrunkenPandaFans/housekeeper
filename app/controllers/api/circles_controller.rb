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
  end
end
