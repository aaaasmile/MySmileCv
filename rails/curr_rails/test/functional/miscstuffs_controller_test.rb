require File.dirname(__FILE__) + '/../test_helper'
require 'miscstuffs_controller'

# Re-raise errors caught by the controller.
class MiscstuffsController; def rescue_action(e) raise e end; end

class MiscstuffsControllerTest < Test::Unit::TestCase
  fixtures :miscstuffs

  def setup
    @controller = MiscstuffsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = miscstuffs(:first).id
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

    assert_not_nil assigns(:miscstuffs)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:miscstuff)
    assert assigns(:miscstuff).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:miscstuff)
  end

  def test_create
    num_miscstuffs = Miscstuff.count

    post :create, :miscstuff => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_miscstuffs + 1, Miscstuff.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:miscstuff)
    assert assigns(:miscstuff).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Miscstuff.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Miscstuff.find(@first_id)
    }
  end
end
