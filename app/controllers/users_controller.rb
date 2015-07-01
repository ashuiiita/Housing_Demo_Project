class UsersController < ApplicationController
	protect_from_forgery :except => :create

	def new
	end
	
	def show
   	  @user = User.find(params[:id])
  	end
  	
  	def index
    	render json: Post.all
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
		lat = (user_log_params[:latitude]).to_f
		lat = lat * 0.0174532925
		lat = lat.round(4)
		lon = (user_log_params[:longitude]).to_f
		lon = lon * 0.0174532925
		lon = lon.round(4)
		if find_user
			r = rand(100)
			userlogin = LoginUser.new(name: find_user[:name], email: user[:email], token: r, latitude: lat, longitude:lon, user_id: find_user[:id])
			userlogin.save
			render json: {name: find_user[:name], email: find_user[:email] , token: r , status: "1" ,latitude: lat , longitude: lon}
		else
			render json: { status: "0"}
		end
	end

	def position_change
		user_login = LoginUser.find_by(email:user_locationchange_params[:email] , token: user_locationchange_params[:token])
		if user_login
			lat = (user_locationchange_params[:latitude]).to_f
			lat = lat * 0.0174532925
			lat = lat.round(4)
			lon = (user_locationchange_params[:longitude]).to_f
			lon = lon * 0.0174532925
			lon = lon.round(4)
			user_login.latitude = lat
			user_login.longitude = lon
			user_login.save
			render json: { status: "1"}
		else
			render json: { status: "0"}
		end
	end


 	private
	  def user_params
	    params.permit(:name, :email,:password,:phone)
	  end

	  def user_params_desk
	  	params.require(:user).permit(:name, :email,:password,:phone)
	  end
	  
	  def user_log_params
	  	params.permit(:email,:password,:latitude,:longitude)
	  end
	
	  def user_find_params
	  	params.permit(:email,:latitude,:longitude)
	  end
	  
	  def user_locationchange_params
	  	params.permit(:email,:token,:latitude,:longitude)
	  end
	 
end
