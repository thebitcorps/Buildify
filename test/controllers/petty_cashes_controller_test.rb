require 'test_helper'

class PettyCashesControllerTest < ActionController::TestCase
  setup do
    @petty_cash = petty_cashes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:petty_cashes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create petty_cash" do
    assert_difference('PettyCash.count') do
      post :create, petty_cash: { amount: @petty_cash.amount, closing_date: @petty_cash.closing_date, construction_id: @petty_cash.construction_id }
    end

    assert_redirected_to petty_cash_path(assigns(:petty_cash))
  end

  test "should show petty_cash" do
    get :show, id: @petty_cash
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @petty_cash
    assert_response :success
  end

  test "should update petty_cash" do
    patch :update, id: @petty_cash, petty_cash: { amount: @petty_cash.amount, closing_date: @petty_cash.closing_date, construction_id: @petty_cash.construction_id }
    assert_redirected_to petty_cash_path(assigns(:petty_cash))
  end

  test "should destroy petty_cash" do
    assert_difference('PettyCash.count', -1) do
      delete :destroy, id: @petty_cash
    end

    assert_redirected_to petty_cashes_path
  end
end
