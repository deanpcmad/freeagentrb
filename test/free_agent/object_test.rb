require "test_helper"

class ObjectTest < Minitest::Test
  def test_creating_object_from_hash
    assert_equal "bar", FreeAgent::Object.new(foo: "bar").foo
  end

  def test_nested_hash
    assert_equal "foobar", FreeAgent::Object.new(foo: { bar: { baz: "foobar" } }).foo.bar.baz
  end

  def test_nested_number
    assert_equal 1, FreeAgent::Object.new(foo: { bar: 1 }).foo.bar
  end

  def test_array
    object = FreeAgent::Object.new(foo: [ { bar: :baz } ])
    assert_equal OpenStruct, object.foo.first.class
    assert_equal :baz, object.foo.first.bar
  end

  class Money < FreeAgent::Object
    decimal_attributes :total_value, :paid_value
  end

  def test_decimal_attributes_are_coerced_to_floats
    object = Money.new("total_value" => "200.0", "paid_value" => "-50.25")

    assert_equal 200.0, object.total_value
    assert_equal(-50.25, object.paid_value)
  end

  def test_decimal_attributes_leave_other_attributes_alone
    object = Money.new("total_value" => "200.0", "exchange_rate" => "1.0")

    assert_equal "1.0", object.exchange_rate
  end

  def test_decimal_attributes_tolerate_missing_and_blank_values
    object = Money.new("total_value" => "")

    assert_equal "", object.total_value
    assert_nil object.paid_value
  end

  def test_decimal_attributes_are_not_inherited_by_unrelated_objects
    assert_equal [], FreeAgent::Object.decimal_attribute_names
    assert_equal "200.0", FreeAgent::Object.new("total_value" => "200.0").total_value
  end
end
