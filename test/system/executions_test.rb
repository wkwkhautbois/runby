require "application_system_test_case"

class ExecutionsTest < ApplicationSystemTestCase
  setup do
    @execution = executions(:one)
  end

  test "visiting the index" do
    visit executions_url
    assert_selector "h1", text: "Executions"
  end

  test "creating a Execution" do
    visit executions_url
    click_on "New Execution"

    click_on "Create Execution"

    assert_text "Execution was successfully created"
    click_on "Back"
  end

  test "updating a Execution" do
    visit executions_url
    click_on "Edit", match: :first

    click_on "Update Execution"

    assert_text "Execution was successfully updated"
    click_on "Back"
  end

  test "destroying a Execution" do
    visit executions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Execution was successfully destroyed"
  end
end
