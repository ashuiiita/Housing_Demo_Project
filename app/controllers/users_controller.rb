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
		lat = (user_log_params[:latitude]).to_f
		lat = lat * 0.0174532925
		lat = lat.round(4)
		lon = (user_log_params[:longitude]).to_f
		lon = lon * 0.0174532925
		lon = lon.round(4)
		if find_user
			r = rand(100)
			userlogin = LoginUser.new(name: find_user[:name], email: user[:email], token: r, latitude: lat, longitude:lon)
			userlogin.save
			render json: {name: find_user[:name], email: find_user[:email] , token: r , status: "1" ,latitude: lat , longitude: lon}
		else
			render json: { status: "0"}
		end
	end

	def find_users
		find_params = user_find_params
		lat = (find_params[:latitude]).to_f
		lat = lat *  0.0174532925
		lat = lat.round(4)
		lon = (find_params[:longitude]).to_f
		lon = lon * 0.0174532925
		lon = lon.round(4)
        nearby_users = Array.new
		LoginUser.all.each do |user|
			t =  user.latitude - lat
			t1 = user.longitude - lon
			t2 = Math.sin(t/2.0) * Math.sin(t/2.0)
			t3 = Math.cos(lat) * Math.cos(user.latitude) * Math.sin(t1/2.0) * Math.sin(t1/2.0) 
			t4 = t2 + t3
		    t5 = Math.sqrt(t4*1.0)
			t6 = 2 * Math.asin(t5)
			t7 = 6371 * t6
			if(t7 <= 100.0)
				user_find = {name: user.name , email: user.email , distance: t7}
				nearby_users.push(user_find)
			end
		end
			render json: nearby_users
	end

 	private
	  def user_params
	    params.permit(:name, :email,:password,:phone)
	  end
	  def user_log_params
	  	params.permit(:email,:password,:latitude,:longitude)
	  end
	  def user_find_params
	  	params.permit(:email,:latitude,:longitude)
	  end

end
