require File.dirname(__FILE__) + '/../test_helper'

class TweetsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:tweets)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_tweet
    assert_difference('Tweet.count') do
      post :create, :tweet => { }
    end

    assert_redirected_to tweet_path(assigns(:tweet))
  end

  def test_should_show_tweet
    get :show, :id => tweets(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => tweets(:one).id
    assert_response :success
  end

  def test_should_update_tweet
    put :update, :id => tweets(:one).id, :tweet => { }
    assert_redirected_to tweet_path(assigns(:tweet))
  end

  def test_should_destroy_tweet
    assert_difference('Tweet.count', -1) do
      delete :destroy, :id => tweets(:one).id
    end

    assert_redirected_to tweets_path
  end
end
