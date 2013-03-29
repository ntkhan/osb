require 'test_helper'

class ClientBillingInfosControllerTest < ActionController::TestCase
  setup do
    @client_billing_info = client_billing_infos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:client_billing_infos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create client_billing_info" do
    assert_difference('ClientBillingInfo.count') do
      post :create, client_billing_info: { city: @client_billing_info.city, country: @client_billing_info.country, fax: @client_billing_info.fax, notes: @client_billing_info.notes, phone_business: @client_billing_info.phone_business, phone_home: @client_billing_info.phone_home, phone_mobile: @client_billing_info.phone_mobile, postal_or_zip_code: @client_billing_info.postal_or_zip_code, province_or_state: @client_billing_info.province_or_state, street_address_1: @client_billing_info.street_address_1, street_address_2: @client_billing_info.street_address_2 }
    end

    assert_redirected_to client_billing_info_path(assigns(:client_billing_info))
  end

  test "should show client_billing_info" do
    get :show, id: @client_billing_info
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @client_billing_info
    assert_response :success
  end

  test "should update client_billing_info" do
    put :update, id: @client_billing_info, client_billing_info: { city: @client_billing_info.city, country: @client_billing_info.country, fax: @client_billing_info.fax, notes: @client_billing_info.notes, phone_business: @client_billing_info.phone_business, phone_home: @client_billing_info.phone_home, phone_mobile: @client_billing_info.phone_mobile, postal_or_zip_code: @client_billing_info.postal_or_zip_code, province_or_state: @client_billing_info.province_or_state, street_address_1: @client_billing_info.street_address_1, street_address_2: @client_billing_info.street_address_2 }
    assert_redirected_to client_billing_info_path(assigns(:client_billing_info))
  end

  test "should destroy client_billing_info" do
    assert_difference('ClientBillingInfo.count', -1) do
      delete :destroy, id: @client_billing_info
    end

    assert_redirected_to client_billing_infos_path
  end
end
