require "application_system_test_case"

class MarkTypesTest < ApplicationSystemTestCase
  setup do
    @mark_type = mark_types(:one)
  end

  test "visiting the index" do
    visit mark_types_url
    assert_selector "h1", text: "Mark Types"
  end

  test "creating a Mark type" do
    visit mark_types_url
    click_on "New Mark Type"

    fill_in "Name", with: @mark_type.name
    click_on "Create Mark type"

    assert_text "Mark type was successfully created"
    click_on "Back"
  end

  test "updating a Mark type" do
    visit mark_types_url
    click_on "Edit", match: :first

    fill_in "Name", with: @mark_type.name
    click_on "Update Mark type"

    assert_text "Mark type was successfully updated"
    click_on "Back"
  end

  test "destroying a Mark type" do
    visit mark_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Mark type was successfully destroyed"
  end
end
