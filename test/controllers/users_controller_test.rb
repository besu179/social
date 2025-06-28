require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                         email: @user.email } }
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(users(:archer))
    get edit_user_path(@user)
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(users(:archer))
    patch user_path(@user), params: { user: { name: @user.name,
                                         email: @user.email } }
    assert_redirected_to root_url
  end

  test "should update user with valid attributes" do
    log_in_as(@user)
    patch user_path(@user), params: { user: { name: "New Name",
                                         email: "new@example.com" } }
    assert_redirected_to @user
    @user.reload
    assert_equal "New Name", @user.name
    assert_equal "new@example.com", @user.email
  end

  test "should not update user with invalid attributes" do
    log_in_as(@user)
    patch user_path(@user), params: { user: { name: "",
                                         email: "invalid" } }
    assert_template 'users/edit'
  end
end
