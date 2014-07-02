class UsersController < ApplicationController
  before_action :authenticate

  def index
    users = User.all
    render json: users, status: 200, root: false
  end

  def show
    id = params[:id]
    if id
      user = User.find_by_id(id)
    else
      user = @current_user
    end

    if user
      render json: user, status: 200, root: false
    else
      render json: { error: "User not found."}, status: 404
    end
  end

  protected

    def authenticate
      authenticate_by_token || render_unauthorized
    end

    def authenticate_by_token
      authenticate_with_http_token do |token, options|
        @current_user = User.find_by(token: token)
      end
    end

    def render_unauthorized
      self.headers["WWW-Authenticate"] = 'Token realm="Users"'
      render json: { error: "Bad credentials."}, status: 401
    end
end
