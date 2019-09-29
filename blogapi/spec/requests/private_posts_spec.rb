require "rails_helper"

RSpec.describe "Posts with authentication", type: :request do

	# Factories for Users
	let!(:user) {create(:user)}
	let!(:other_user) {create(:user)}
	# Factories for Posts
	let!(:user_post) {create(:post, user_id: user.id)}
	let!(:other_user_post) {create(:post, user_id: other_user.id, published: true)}
	let!(:other_user_post_draft) {create(:post, user_id: other_user.id, published: false)}
	# Fixtures for Auth Headers with tokens
	let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
  	let!(:other_auth_headers) { { 'Authorization' => "Bearer #{other_user.auth_token}" } }


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
			context "when requesting user's post" do

			end
		end
	end

	describe "Create: GET /posts" do

	end

	describe "Update: PUT /posts" do

	end

	private

	def payload
		JSON.parse(response.body).with_indifferent_access
	end





end