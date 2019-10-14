require "rails_helper"

RSpec.describe "Posts with authentication", type: :request do

	# Factories for Users
	let!(:user) {create(:user)}
	let!(:other_user) {create(:user)}
	# Factories for Posts
	let!(:user_post) {create(:post, user_id: user.id)}
	let!(:other_user_post) {create(:post, user_id: other_user.id, published: true)}
	let!(:user_post_draft) {create(:post, user_id: user.id, published: false)}
	let!(:other_user_post_draft) {create(:post, user_id: other_user.id, published: false)}
	# Fixtures for Auth Headers with tokens
	let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
  	let!(:other_auth_headers) { { 'Authorization' => "Bearer #{other_user.auth_token}" } }
  	# Fixtures for request body
  	let!(:create_post_params) { { "post" => {"title" => "title", "content" => "content", "published" => true}} }
  	let!(:update_post_params) { { "post" => {"title" => "title", "content" => "content", "published" => true}} }


	describe "Detail: GET /posts/{id}" do
		context "with valid auth" do
			context "when requesting other's author post" do

				context "when post is public" do
					before { get "/posts/#{other_user_post.id}", headers: auth_headers }

					context "payload" do
						subject { payload }
						it { is_expected.to include(:id) }
					end
					context "response" do
						subject { response }
						it { is_expected.to have_http_status(:ok) }
					end
				end

				context "when post is a draft" do
					before { get "/posts/#{other_user_post_draft.id}", headers: auth_headers}
					
					context "payload" do
						subject { payload }
						it { is_expected.to include(:error) }
					end
					context "response" do
						subject { response }
						it { is_expected.to have_http_status(:not_found) }
					end
				end


			end
			# context "when requesting user's post" do
			# 	context "when post is a draft" do
			# 		before { get "/posts/#{user_post_draft.id}", headers: auth_headers}
					
			# 		context "payload" do
			# 			subject { payload }
			# 			it { is_expected.to include(:id) }
			# 		end
			# 		context "response" do
			# 			subject { response }
			# 			it { is_expected.to have_http_status(:ok) }
			# 		end
			# 	end

			# end
		end
	end

	describe "Create: GET /posts" do
		# with auth: Create
		context "with valid auth" do
			before { post "/posts", params: create_post_params, headers: auth_headers}
			
			context "payload" do
				subject { payload }
				it { is_expected.to include(:id, :title, :content, :published, :author) }
			end
			context "response" do
				subject { response }
				it { is_expected.to have_http_status(:created) }
			end
		end
		# without auth: !Create -> 401
		context "without auth" do
			before { post "/posts", params: create_post_params}
			
			context "payload" do
				subject { payload }
				it { is_expected.to include(:error) }
			end
			context "response" do
				subject { response }
				it { is_expected.to have_http_status(:unauthorized) }
			end
		end

	end

	describe "Update: PUT /posts" do
		# with auth:
			# update own post
			# !update others post -> 401
		context "with valid auth" do
			context "when updating users's post" do
				before { put "/posts/#{user_post.id}", params: update_post_params, headers: auth_headers}

				context "payload" do
					subject { payload }
					it { is_expected.to include(:id, :title, :content, :published, :author) }
					it { expect(payload[:id]).to eq(user_post.id) }
				end
				context "response" do
					subject { response }
					it { is_expected.to have_http_status(:ok) }
				end
			end

			context "when updating other users's post" do
				before { put "/posts/#{other_user_post.id}", params: update_post_params, headers: auth_headers}

				context "payload" do
					subject { payload }
					it { is_expected.to include(:error) }
				end
				context "response" do
					subject { response }
					it { is_expected.to have_http_status(:not_found) }
				end
			end


		end


	end

	private

	def payload
		JSON.parse(response.body).with_indifferent_access
	end





end