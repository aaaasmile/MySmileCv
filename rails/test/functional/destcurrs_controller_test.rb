require File.dirname(__FILE__) + '/../test_helper'
require 'destcurrs_controller'

# Re-raise errors caught by the controller.
class DestcurrsController; def rescue_action(e) raise e end; end

class DestcurrsControllerTest < Test::Unit::TestCase
  fixtures :destcurrs

  def setup
    @controller = DestcurrsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = destcurrs(:first).id
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

    assert_not_nil assigns(:destcurrs)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:destcurr)
    assert assigns(:destcurr).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:destcurr)
  end

  def test_create
    num_destcurrs = Destcurr.count

    post :create, :destcurr => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_destcurrs + 1, Destcurr.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:destcurr)
    assert assigns(:destcurr).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Destcurr.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Destcurr.find(@first_id)
    }
  end
end
