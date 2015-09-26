require 'test_helper'

class MesureUnitsControllerTest < ActionController::TestCase
  setup do
    @mesure_unit = mesure_units(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mesure_units)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mesure_unit" do
    assert_difference('MesureUnit.count') do
      post :create, mesure_unit: { abbreviation: @mesure_unit.abbreviation, unit: @mesure_unit.unit }
    end

    assert_redirected_to mesure_unit_path(assigns(:mesure_unit))
  end

  test "should show mesure_unit" do
    get :show, id: @mesure_unit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mesure_unit
    assert_response :success
  end

  test "should update mesure_unit" do
    patch :update, id: @mesure_unit, mesure_unit: { abbreviation: @mesure_unit.abbreviation, unit: @mesure_unit.unit }
    assert_redirected_to mesure_unit_path(assigns(:mesure_unit))
  end

  test "should destroy mesure_unit" do
    assert_difference('MesureUnit.count', -1) do
      delete :destroy, id: @mesure_unit
    end

    assert_redirected_to mesure_units_path
  end
end
