require File.dirname(__FILE__) + '/../test_helper'
require 'loadcurr_controller'

# Re-raise errors caught by the controller.
class LoadcurrController; def rescue_action(e) raise e end; end

class LoadcurrControllerTest < Test::Unit::TestCase
  def setup
    @controller = LoadcurrController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
