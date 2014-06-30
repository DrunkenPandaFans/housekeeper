class UsersController < ApplicationController
  before_action :authenticate

  def show
    id = params[:id]
    user = User.find(id) if id
    user ||= @current_user

    render json: user, status: 200
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
      render json: "Bad credentials", status: 401
    end
end
