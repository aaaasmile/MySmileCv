require File.dirname(__FILE__) + '/../test_helper'
require 'identities_controller'

# Re-raise errors caught by the controller.
class IdentitiesController; def rescue_action(e) raise e end; end

class IdentitiesControllerTest < Test::Unit::TestCase
  fixtures :identities

  def setup
    @controller = IdentitiesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = identities(:first).id
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

    assert_not_nil assigns(:identities)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:identity)
    assert assigns(:identity).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:identity)
  end

  def test_create
    num_identities = Identity.count

    post :create, :identity => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_identities + 1, Identity.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:identity)
    assert assigns(:identity).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Identity.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Identity.find(@first_id)
    }
  end
end
