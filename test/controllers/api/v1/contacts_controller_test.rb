require "test_helper"

class Api::V1::ContactsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_v1_contacts_create_url
    assert_response :success
  end
end
