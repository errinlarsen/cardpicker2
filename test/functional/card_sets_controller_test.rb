require 'test_helper'

class CardSetsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:card_sets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create card_set" do
    assert_difference('CardSet.count') do
      post :create, :card_set => { }
    end

    assert_redirected_to card_set_path(assigns(:card_set))
  end

  test "should show card_set" do
    get :show, :id => card_sets(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => card_sets(:one).to_param
    assert_response :success
  end

  test "should update card_set" do
    put :update, :id => card_sets(:one).to_param, :card_set => { }
    assert_redirected_to card_set_path(assigns(:card_set))
  end

  test "should destroy card_set" do
    assert_difference('CardSet.count', -1) do
      delete :destroy, :id => card_sets(:one).to_param
    end

    assert_redirected_to card_sets_path
  end
end
