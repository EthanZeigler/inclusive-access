require 'test_helper'

class MarkTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mark_type = mark_types(:one)
  end

  test "should get index" do
    get mark_types_url
    assert_response :success
  end

  test "should get new" do
    get new_mark_type_url
    assert_response :success
  end

  test "should create mark_type" do
    assert_difference('MarkType.count') do
      post mark_types_url, params: { mark_type: { name: @mark_type.name } }
    end

    assert_redirected_to mark_type_url(MarkType.last)
  end

  test "should show mark_type" do
    get mark_type_url(@mark_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_mark_type_url(@mark_type)
    assert_response :success
  end

  test "should update mark_type" do
    patch mark_type_url(@mark_type), params: { mark_type: { name: @mark_type.name } }
    assert_redirected_to mark_type_url(@mark_type)
  end

  test "should destroy mark_type" do
    assert_difference('MarkType.count', -1) do
      delete mark_type_url(@mark_type)
    end

    assert_redirected_to mark_types_url
  end
end
