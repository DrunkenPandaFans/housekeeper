class CirclesController < ApplicationController
  def index
    circles = Circle.all
    name = params[:name]

    if name
      circles = circles.where("lower(name) like ?",
        "%#{name.downcase}%")
    end

    render json: circles, status: 200, root: false
  end
end
