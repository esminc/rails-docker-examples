require 'test_helper'

class FrontendControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get frontend_show_url
    assert_response :success
  end

end
