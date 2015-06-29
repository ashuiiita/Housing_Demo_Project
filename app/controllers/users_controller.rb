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
	  user = User.new(params.require(:user).permit(:name, :email, :password, :phonenumber))
	  noUser = {status:"0"}
	  yesUser = {status:"1"}
	 
	  if User.find_by email: @user[:email]
	  	render json: noUser
	  else
	  	user.save
	  	render json: yesUser
	  end
	end
	
	#TODO better token system and password hashing
	def authenticate
		user = User.new(params.require(:user).permit(:email, :password))
		find_user = User.find_by(email: user.email, password: user.password)
		if find_user
			r = rand(100)
			userlogin = LoginUser.new(user_id: find_user.id, token: r) 
			userlogin.save
			render json: { token: r , status: "1" }
		else
			render json: { status: "0"}
		end
	end

 	private
	
	def user_params
	    params.permit(:name, :email,:password,:phone)
	end
	
	def user_log_params
	  	params.permit(:email,:password,:latitude,:longitude)
	end

end
