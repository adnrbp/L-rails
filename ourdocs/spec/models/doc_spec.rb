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

    # it "considers a doc with no tasks to be done" do
    #     # Arrange
    #     doc = Doc.new
    #     # Assert
    #     expect(doc.done?).to be_truthy
    # end
    # it "knows that a doc with an incomplete task is not done" do
    #     # Arrange
    #     doc = Doc.new
    #     task = Task.new
    #     # Act
    #     doc.tasks << task
    #     # Assert
    #     expect(doc.done?).to be_falsy
    # end


end