require File.dirname(__FILE__) + '/../test_helper'
require 'languageskills_controller'

# Re-raise errors caught by the controller.
class LanguageskillsController; def rescue_action(e) raise e end; end

class LanguageskillsControllerTest < Test::Unit::TestCase
  fixtures :languageskills

  def setup
    @controller = LanguageskillsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = languageskills(:first).id
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

    assert_not_nil assigns(:languageskills)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:languageskill)
    assert assigns(:languageskill).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:languageskill)
  end

  def test_create
    num_languageskills = Languageskill.count

    post :create, :languageskill => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_languageskills + 1, Languageskill.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:languageskill)
    assert assigns(:languageskill).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Languageskill.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Languageskill.find(@first_id)
    }
  end
end
