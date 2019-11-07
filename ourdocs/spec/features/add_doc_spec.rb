require "rails_helper"

describe "adding docs" do
    it "allows a user to create a doc" do
        # Arrange
        visit new_doc_path
        fill_in "Title", with: "Document Runway"
        fill_in "Content", with: "Sample Document Text"
        # Act
        click_on("Create Document")
        visit docs_path
        # Assert
        expect(page).to have_content("Document Runway")
        expect(page).to have_content("Sample")
    end
end