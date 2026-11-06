require "application_system_test_case"

class TrailBrowsingTest < ApplicationSystemTestCase
  test "home page shows trail search and main navigation" do
    visit root_path

    assert_selector "h1", text: "Find your next trail"
    assert_selector "nav[aria-label='Main navigation']"
    assert_field "Search trails and parks"
  end
end
