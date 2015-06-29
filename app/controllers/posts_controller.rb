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
	  post = Post.new(post_params)
	  fail = {status:"0"}
	  success = {status:"1"}
	 
	  if User.find(post[:user_id])
	  	post.save
	  	render json: success
	  else
	  	render json: fail
	  end
	end

	def post_params
	  	params.require(:post).permit(:content, :user_id)
	  end

end
