module API
  class AuthenticationController < ApplicationController
     before_action :authenticate

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

      def user_params
        params.permit(:name, :email, :image, :send_sms)
      end
 end
end
