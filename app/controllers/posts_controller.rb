class PostsController < ApplicationController
	protect_from_forgery :except => :create

	def show
   	  @post = Post.find(params[:id])
  	end
  	
  	def index
  		@posts = Post.all
  	end

  	def getAll
  		render json: Post.all
  	end

	def create
	  fail = {status:"0"}
	  success = {status:"1"}
	  user_id = LoginUser.find_by(token: post_params[:token], email:post_params[:email])
	  lat_rad = (post_params[:latitude]).to_f
	  lat_rad = lat_rad * 0.0174532925
	  lat_rad = lat_rad.round(4)
	  lon_rad = (post_params[:longitude]).to_f
	  lon_rad = lon_rad * 0.0174532925
	  lon_rad = lon_rad.round(4)
	  
	  post = Post.new(content: post_params[:content], user_id: user_id[:user_id], latitude: lat_rad , longitude: lon_rad)
	  
	  if User.find(user_id[:user_id])
	  	post.save
	  	render json: success
	  else
	  	render json: fail
	  end
	end

	def find_nearby_posts
		find_params = user_find_params
		lat = (find_params[:latitude]).to_f
		lat = lat *  0.0174532925
		lat = lat.round(4)
		lon = (find_params[:longitude]).to_f
		lon = lon * 0.0174532925
		lon = lon.round(4)
        nearby_users = Array.new
        nearby_users_ids = Array.new
        nearby_users_array = Array.new
		LoginUser.all.each do |user|
			t =  user.latitude - lat
			t1 = user.longitude - lon
			t2 = Math.sin(t/2.0) * Math.sin(t/2.0)
			t3 = Math.cos(lat) * Math.cos(user.latitude) * Math.sin(t1/2.0) * Math.sin(t1/2.0) 
			t4 = t2 + t3
		    t5 = Math.sqrt(t4*1.0)
			t6 = 2 * Math.asin(t5)
			t7 = 6371 * t6
			if(t7 <= 100.0 && user.email != find_params[:email])
				user_find = {userId: user.user_id,name: user.name , email: user.email , distance: t7}
				nearby_users.push(user_find)
				nearby_users_ids.push(user.user_id)
			end
		end
		all_users = Post.where("user_id in (?)", nearby_users_ids)
		nearby_users_array.push(all_users)
		render json: {user_list: nearby_users_array}  
	end
		
	def post_params
	  	params.permit(:content, :email, :token, :latitude, :longitude)
	end
	
	def user_find_params
		params.permit(:token, :email,:latitude,:longitude)
	end

end
