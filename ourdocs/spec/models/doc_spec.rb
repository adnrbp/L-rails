require 'rails_helper'

RSpec.describe Doc, type: :model do
    describe 'columns' do
        it { is_expected.to have_db_column(:title)}
        it { is_expected.to have_db_column(:content)}
        #it { should have_db_column(:support)}
    end

    describe "validations" do 
        it "validate presence of required fields" do
            should validate_presence_of(:title)
            should validate_presence_of(:content)
        end
    end

    describe "relations" do
        it { should belong_to(:user) }
    end


end