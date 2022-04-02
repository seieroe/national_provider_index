require "test_helper"

class ProviderDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @provider_detail = provider_details(:one)
  end

  test "should get index" do
    get provider_details_url
    assert_response :success
  end

  test "should get new" do
    get new_provider_detail_url
    assert_response :success
  end

  test "should create provider_detail" do
    assert_difference("ProviderDetail.count") do
      post provider_details_url, params: { provider_detail: { address: @provider_detail.address, name: @provider_detail.name, npi: @provider_detail.npi, taxonomy: @provider_detail.taxonomy, type: @provider_detail.type } }
    end

    assert_redirected_to provider_detail_url(ProviderDetail.last)
  end

  test "should show provider_detail" do
    get provider_detail_url(@provider_detail)
    assert_response :success
  end

  test "should get edit" do
    get edit_provider_detail_url(@provider_detail)
    assert_response :success
  end

  test "should update provider_detail" do
    patch provider_detail_url(@provider_detail), params: { provider_detail: { address: @provider_detail.address, name: @provider_detail.name, npi: @provider_detail.npi, taxonomy: @provider_detail.taxonomy, type: @provider_detail.type } }
    assert_redirected_to provider_detail_url(@provider_detail)
  end

  test "should destroy provider_detail" do
    assert_difference("ProviderDetail.count", -1) do
      delete provider_detail_url(@provider_detail)
    end

    assert_redirected_to provider_details_url
  end
end
