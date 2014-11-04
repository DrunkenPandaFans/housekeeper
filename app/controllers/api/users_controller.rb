module API
  class UsersController < AuthenticationController
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

    def update
      if @current_user.update(user_params)
        render json: @current_user, status: 200, root: false
      else
        render json: @current_user.errors.full_messages, status: 422
      end
    end

  end
end
