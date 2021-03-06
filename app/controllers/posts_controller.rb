class PostsController < ApplicationController
   before_action :authenticate_user!, except: [:index, :show]
   before_action :find_post, only: [:show, :edit, :update, :destroy, :upvote, :downvote]

	def index 
		if params[:search]
    		@posts = Post.search(params[:search]).order("created_at DESC")
  		else
    		@posts = Post.all
  		end
	end

	def new	
		@post = current_user.posts.build	
	end

	def create
		@post = current_user.posts.build(post_params)
		if @post.save
			redirect_to @post
		else
			render 'new'
		end
	end

	def destroy
		@post.destroy
		redirect_to root_path
	end

	def show
		@comments = Comment.where(post_id: @post)
		@random_post = Post.where.not(id: @post).order("RANDOM()").first
	end

	def edit

	end

	def upvote
		@post.upvote_by current_user
		redirect_to :back
	end

	def downvote
		@post.downvote_by current_user
		redirect_to :back
	end

	def update
		if @post.update(post_params)
			redirect_to @post
		else
			render 'edit'
		end	
	end


	private
		def find_post
			@post=Post.find(params[:id])
		end

		def post_params
      		params.require(:post).permit(:title, :photo, :content)
    	end
end
