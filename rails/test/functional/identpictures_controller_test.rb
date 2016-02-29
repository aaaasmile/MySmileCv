require File.dirname(__FILE__) + '/../test_helper'
require 'identpictures_controller'

# Re-raise errors caught by the controller.
class IdentpicturesController; def rescue_action(e) raise e end; end

class IdentpicturesControllerTest < Test::Unit::TestCase
  fixtures :identpictures

  def setup
    @controller = IdentpicturesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = identpictures(:first).id
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

    assert_not_nil assigns(:identpictures)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:identpicture)
    assert assigns(:identpicture).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:identpicture)
  end

  def test_create
    num_identpictures = Identpicture.count

    post :create, :identpicture => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_identpictures + 1, Identpicture.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:identpicture)
    assert assigns(:identpicture).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Identpicture.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Identpicture.find(@first_id)
    }
  end
end
