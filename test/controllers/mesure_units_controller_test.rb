require 'test_helper'

class MesureUnitsControllerTest < ActionController::TestCase
  setup do
    @measure_unit = mesure_units(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:measure_units)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create measure_unit" do
    assert_difference('MeasureUnit.count') do
      post :create, measure_unit: { abbreviation: @measure_unit.abbreviation, unit: @measure_unit.unit }
    end

    assert_redirected_to mesure_unit_path(assigns(:measure_unit))
  end

  test "should show measure_unit" do
    get :show, id: @measure_unit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @measure_unit
    assert_response :success
  end

  test "should update measure_unit" do
    patch :update, id: @measure_unit, measure_unit: { abbreviation: @measure_unit.abbreviation, unit: @measure_unit.unit }
    assert_redirected_to mesure_unit_path(assigns(:measure_unit))
  end

  test "should destroy measure_unit" do
    assert_difference('MeasureUnit.count', -1) do
      delete :destroy, id: @measure_unit
    end

    assert_redirected_to mesure_units_path
  end
end
