class PostsController < ApplicationController
	before_action :authenticate_user!, only: [:create, :update]

	rescue_from Exception do |e|
		render json: {error: e.message}, status: :internal_error
	end

	rescue_from ActiveRecord::RecordNotFound do |e|
		render json: {error: e.message}, status: :not_found
	end

	rescue_from ActiveRecord::RecordInvalid do |e|
		render json: {error: e.message}, status: :unprocessable_entity
	end



	# GET /post
	def index
		@posts = Post.where(published: true).includes(:user)
		if !params[:search].nil? && params[:search].present?
			@posts = PostsSearchService.search(@posts, params[:search])
		end
		render json: @posts, status: :ok
	end

	# GET /post/{id}
	def show
		@post = Post.find(params[:id])
		isAuthenticated = Current.user

		if(@post.published? || (isAuthenticated && isPostOwner(Current.user, @post)))
			render json: @post, status: :ok
		else
			render json: {error: 'Not Found'}, status: :not_found
		end
	end

	# POST /posts
	def create
		@post = Current.user.posts.create!(create_params)
		render json: @post, status: :created
	end

	# PUT /posts{id}
	def update
		@post = Current.user.posts.find(params[:id])
		@post.update!(update_params)
		render json: @post, status: :ok

	end


	private

	def create_params
		params.require(:post).permit(:title, :content, :published)
	end
	
	def update_params
		params.require(:post).permit(:title, :content, :published)
	end

	def authenticate_user!
		token_regex = /Bearer (\w+)/
		# Read auth Header
		headers = request.headers
		# verify valid Header with token
		if headers['Authorization'].present? && headers['Authorization'].match(token_regex)
			token = headers['Authorization'].match(token_regex)[1]
			# verify token belongs to user
			if(Current.user = User.find_by_auth_token(token))
				return
			end
		end
		render json: {error: 'Unauthorized'}, status: :unauthorized
	end


	def isPostOwner(user,object)
		if (object.user_id == user.id)
			true
		else
			false
		end
	end

end