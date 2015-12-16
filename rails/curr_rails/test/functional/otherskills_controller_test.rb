require File.dirname(__FILE__) + '/../test_helper'
require 'otherskills_controller'

# Re-raise errors caught by the controller.
class OtherskillsController; def rescue_action(e) raise e end; end

class OtherskillsControllerTest < Test::Unit::TestCase
  fixtures :otherskills

  def setup
    @controller = OtherskillsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = otherskills(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:otherskills)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:otherskill)
    assert assigns(:otherskill).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:otherskill)
  end

  def test_create
    num_otherskills = Otherskill.count

    post :create, :otherskill => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_otherskills + 1, Otherskill.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:otherskill)
    assert assigns(:otherskill).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Otherskill.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Otherskill.find(@first_id)
    }
  end
end
