require "application_system_test_case"

class MarksTest < ApplicationSystemTestCase
  setup do
    @mark = marks(:one)
  end

  test "visiting the index" do
    visit marks_url
    assert_selector "h1", text: "Marks"
  end

  test "creating a Mark" do
    visit marks_url
    click_on "New Mark"

    fill_in "Description", with: @mark.description
    fill_in "Lat", with: @mark.lat
    fill_in "Location", with: @mark.location_id
    fill_in "Long", with: @mark.long
    fill_in "Mark type", with: @mark.mark_type_id
    fill_in "Name", with: @mark.name
    fill_in "User", with: @mark.user_id
    click_on "Create Mark"

    assert_text "Mark was successfully created"
    click_on "Back"
  end

  test "updating a Mark" do
    visit marks_url
    click_on "Edit", match: :first

    fill_in "Description", with: @mark.description
    fill_in "Lat", with: @mark.lat
    fill_in "Location", with: @mark.location_id
    fill_in "Long", with: @mark.long
    fill_in "Mark type", with: @mark.mark_type_id
    fill_in "Name", with: @mark.name
    fill_in "User", with: @mark.user_id
    click_on "Update Mark"

    assert_text "Mark was successfully updated"
    click_on "Back"
  end

  test "destroying a Mark" do
    visit marks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Mark was successfully destroyed"
  end
end
