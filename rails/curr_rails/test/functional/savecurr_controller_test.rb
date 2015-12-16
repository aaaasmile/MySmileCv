require File.dirname(__FILE__) + '/../test_helper'
require 'savecurr_controller'

# Re-raise errors caught by the controller.
class SavecurrController; def rescue_action(e) raise e end; end

class SavecurrControllerTest < Test::Unit::TestCase
  def setup
    @controller = SavecurrController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
