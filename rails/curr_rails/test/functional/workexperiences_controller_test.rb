require File.dirname(__FILE__) + '/../test_helper'
require 'workexperiences_controller'

# Re-raise errors caught by the controller.
class WorkexperiencesController; def rescue_action(e) raise e end; end

class WorkexperiencesControllerTest < Test::Unit::TestCase
  fixtures :workexperiences

  def setup
    @controller = WorkexperiencesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = workexperiences(:first).id
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

    assert_not_nil assigns(:workexperiences)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:workexperience)
    assert assigns(:workexperience).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:workexperience)
  end

  def test_create
    num_workexperiences = Workexperience.count

    post :create, :workexperience => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_workexperiences + 1, Workexperience.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:workexperience)
    assert assigns(:workexperience).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Workexperience.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Workexperience.find(@first_id)
    }
  end
end
