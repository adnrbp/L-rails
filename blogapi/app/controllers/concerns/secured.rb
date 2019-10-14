module Secured
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
end