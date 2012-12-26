require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  setup do
    @client = clients(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clients)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create client" do
    assert_difference('Client.count') do
      post :create, client: { email: @client.email, first_name: @client.first_name, last_login: @client.last_login, last_name: @client.last_name, organization: @client.organization, password: @client.password, sec_adrs_city: @client.sec_adrs_city, sec_adrs_country: @client.sec_adrs_country, sec_adrs_post_or_zip_code: @client.sec_adrs_post_or_zip_code, sec_adrs_province_or_state: @client.sec_adrs_province_or_state, sec_adrs_street_address_1: @client.sec_adrs_street_address_1, sec_adrs_street_address_2: @client.sec_adrs_street_address_2, status: @client.status, user_name: @client.user_name }
    end

    assert_redirected_to client_path(assigns(:client))
  end

  test "should show client" do
    get :show, id: @client
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @client
    assert_response :success
  end

  test "should update client" do
    put :update, id: @client, client: { email: @client.email, first_name: @client.first_name, last_login: @client.last_login, last_name: @client.last_name, organization: @client.organization, password: @client.password, sec_adrs_city: @client.sec_adrs_city, sec_adrs_country: @client.sec_adrs_country, sec_adrs_post_or_zip_code: @client.sec_adrs_post_or_zip_code, sec_adrs_province_or_state: @client.sec_adrs_province_or_state, sec_adrs_street_address_1: @client.sec_adrs_street_address_1, sec_adrs_street_address_2: @client.sec_adrs_street_address_2, status: @client.status, user_name: @client.user_name }
    assert_redirected_to client_path(assigns(:client))
  end

  test "should destroy client" do
    assert_difference('Client.count', -1) do
      delete :destroy, id: @client
    end

    assert_redirected_to clients_path
  end
end
