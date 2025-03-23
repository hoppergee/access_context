# frozen_string_literal: true

require "test_helper"

class TestAccessContextRole < ApplicationTest

  def test_initialize
    assert_equal "admin", AccessContext::Role.new("admin", "read_orders").name
    assert_equal [:read_orders], AccessContext::Role.new("admin", "read_orders").permission_names
    assert_equal [:read_orders], AccessContext::Role.new("admin", ["read_orders"]).permission_names
    assert_equal [:read_orders], AccessContext::Role.new("admin", [:read_orders]).permission_names
    assert_equal [:read_orders, :write_orders], AccessContext::Role.new("admin", [:read_orders, "write_orders"]).permission_names
  end

  def test_add_permissions
    role = AccessContext::Role.new("admin", "read_orders")
    assert_equal [:read_orders], role.permission_names
    role.add_permissions("write_orders")
    assert_equal [:read_orders, :write_orders], role.permission_names
    role.add_permissions([:create_user])
    assert_equal [:read_orders, :write_orders, :create_user], role.permission_names
    role.add_permissions([:create_user])
    assert_equal [:read_orders, :write_orders, :create_user], role.permission_names
  end

  def test_permissions
    role = AccessContext::Role[:admin]
    assert_equal 3, role.permissions.count
    assert_equal :default, role.permissions[0].name
    assert_equal :order_read, role.permissions[1].name
    assert_equal :admin_default, role.permissions[2].name

    role = AccessContext::Role[:support]
    assert_equal 2, role.permissions.count
    assert_equal :default, role.permissions[0].name
    assert_equal :order_read, role.permissions[1].name
  end

end
