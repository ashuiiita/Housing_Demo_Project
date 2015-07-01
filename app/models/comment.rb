class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  def get_comments_of_post(post_id) 
  	render Post.where("post_id = :post_id", {post_id: post_id})
  end

end
