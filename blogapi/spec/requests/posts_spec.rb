require "rails_helper"

RSpec.describe "Posts", type: :request do

	describe "GET /posts" do
		#before { get "/posts"}

		it "should return OK" do
			get "/posts"
			payload = JSON.parse(response.body)
			expect(payload).to be_empty
			expect(response).to have_http_status(200)
		end

		describe "Search a post" do
			let!(:comercial_article) { create(:published_post, title: 'comercial article')}
			let!(:economics_article) { create(:published_post, title: 'economics article')}
			let!(:world_news) { create(:published_post, title: 'World news')}

			it "should filter post by title" do
				get '/posts?search=article'
				payload = JSON.parse(response.body)
				expect(payload).to_not be_empty
				expect(payload.size).to eq(2)
				# Specific results are present
				expect(payload.map { |p| p["id"]}.sort ).to eq([comercial_article.id, economics_article.id].sort)
				expect(response).to have_http_status(200)

			end
		end

	end

	describe "GET /posts with data in the DB" do 
		let!(:posts){create_list(:post,10, published: true)}

		it "should return all the published posts" do
			get '/posts'
			payload = JSON.parse(response.body)

			expect(payload.size).to eq(posts.size)
			expect(response).to have_http_status(200)
		end
	end

	describe "GET /posts/{id}" do
		let!(:post){create(:post, published: true)}
		
		it "should return a post" do
			get "/posts/#{post.id}"
			payload = JSON.parse(response.body)

			expect(payload).to_not be_empty
			expect(payload["id"]).to eq(post.id)
			expect(payload["title"]).to eq(post.title)
			expect(payload["content"]).to eq(post.content)
			expect(payload["published"]).to eq(post.published)
			expect(payload["author"]["name"]).to eq(post.user.name)
			expect(payload["author"]["email"]).to eq(post.user.email)
			expect(payload["author"]["id"]).to eq(post.user.id)
			expect(response).to have_http_status(200)
		end
	end

end