require "application_system_test_case"

class ProviderDetailsTest < ApplicationSystemTestCase
  setup do
    @provider_detail = provider_details(:one)
  end

  test "visiting the index" do
    visit provider_details_url
    assert_selector "h1", text: "Provider details"
  end

  test "should create provider detail" do
    visit provider_details_url
    click_on "New provider detail"

    fill_in "Address", with: @provider_detail.address
    fill_in "Name", with: @provider_detail.name
    fill_in "Npi", with: @provider_detail.npi
    fill_in "Taxonomy", with: @provider_detail.taxonomy
    fill_in "Type", with: @provider_detail.type
    click_on "Create Provider detail"

    assert_text "Provider detail was successfully created"
    click_on "Back"
  end

  test "should update Provider detail" do
    visit provider_detail_url(@provider_detail)
    click_on "Edit this provider detail", match: :first

    fill_in "Address", with: @provider_detail.address
    fill_in "Name", with: @provider_detail.name
    fill_in "Npi", with: @provider_detail.npi
    fill_in "Taxonomy", with: @provider_detail.taxonomy
    fill_in "Type", with: @provider_detail.type
    click_on "Update Provider detail"

    assert_text "Provider detail was successfully updated"
    click_on "Back"
  end

  test "should destroy Provider detail" do
    visit provider_detail_url(@provider_detail)
    click_on "Destroy this provider detail", match: :first

    assert_text "Provider detail was successfully destroyed"
  end
end
