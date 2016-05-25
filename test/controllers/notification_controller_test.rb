require 'test_helper'

class NotificationControllerTest < ActionController::TestCase
  test "should get seen" do
    get :seen
    assert_response :success
  end

end
