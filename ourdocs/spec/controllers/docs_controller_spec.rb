require 'rails_helper'

RSpec.describe DocsController, type: :controller do 
    describe 'GET index' do 
        context 'when some docs present' do
            it "assigns @docs" do 
                doc = Doc.create
                get :index
                expect(assigns(:docs)).to eq([doc])
            end
        end

        context 'when no docs' do
            it "assigns @docs" do 
                get :index
                expect(assigns(:docs)).to eq([])
            end
        end

        it 'renders the index template' do
            get :index
            expect(response).to render_template(:index)
        end
    end
end
