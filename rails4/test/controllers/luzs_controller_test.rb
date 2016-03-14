require 'test_helper'

class LuzsControllerTest < ActionController::TestCase
  setup do
    @luz = luzs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:luzs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create luz" do
    assert_difference('Luz.count') do
      post :create, luz: {  }
    end

    assert_redirected_to luz_path(assigns(:luz))
  end

  test "should show luz" do
    get :show, id: @luz
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @luz
    assert_response :success
  end

  test "should update luz" do
    patch :update, id: @luz, luz: {  }
    assert_redirected_to luz_path(assigns(:luz))
  end

  test "should destroy luz" do
    assert_difference('Luz.count', -1) do
      delete :destroy, id: @luz
    end

    assert_redirected_to luzs_path
  end
end
