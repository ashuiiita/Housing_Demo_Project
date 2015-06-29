class PostsController < ApplicationController
	def new
		
	end

	def show
   	  @post = Post.find(params[:id])
  	end
  	
  	def index
  		@posts = Post.all
  	end

	def create
	  fail = {status:"0"}
	  success = {status:"1"}
	  user_id = LoginUser.find_by(token: post_params[:token], email:post_params[:email])
	  post = Post.new(content: post_params[:content], user_id: user_id)

	  if User.find(user_id)
	  	post.save
	  	render json: success
	  else
	  	render json: fail
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
		nearby_users
	end

	def post_params
	  	params.require(:post).permit(:content, :email, :token)
	end

end
