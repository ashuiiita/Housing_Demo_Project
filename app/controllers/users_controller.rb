class UsersController < ApplicationController
	protect_from_forgery :except => :create
	def new
	end
	def show
   	  @user = User.find(params[:id])
  	end
  	def index
    	@users = User.all
  	end
	def create
	  @user = User.new(user_params)
	  @noUser = {status:"0"}
	  @yesUser = {status:"1"}
	 
	  if User.find_by email: @user[:email]
	  	render json: @noUser
	  else
	  	@user.save
	  	render json: @yesUser
	  end

	end
	def authenticate
		user = user_log_params;
		find_user = User.find_by(email: user[:email],password: user[:password])
		
		if find_user
			r = rand(100)
			userlogin = LoginUser.new(name: user[:name], email: user[:email], token: r) 
			userlogin.save
			render json: {name: find_user[:name], email: find_user[:email] , token: r , status: "1"}
		else
			render json: { status: "0"}
		end
	end

 	private
	  def user_params
	    params.permit(:name, :email,:password)
	  end
	  def user_log_params
	  	params.permit(:email,:password)
	  end

end
