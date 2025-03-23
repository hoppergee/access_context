# frozen_string_literal: true

require "test_helper"

class TestAccessContextPermission < ApplicationTest

  def test_permit
    permission = ->(name) { AccessContext::Permission[name] }

    assert permission.(:default).permit?(AccessContext.controller(:home, :show))
    assert permission.(:default).permit?(AccessContext.controller(:dashboard, :show))
    assert permission.(:default).permit?(AccessContext.service(:visit, :call))
    assert permission.(:default).permit?(AccessContext.job(:welcome, :perform))

    assert permission.(:admin_default).permit?(AccessContext.controller("admin/dashboard", :show))
    assert permission.(:admin_default).permit?(AccessContext.controller("admin/orders", :show))

    assert permission.(:order_read).permit?(AccessContext.controller(:orders, :show))
    assert permission.(:order_read).permit?(AccessContext.view("admin/orders", :order_edit_button))
  end

  def test_all
    assert_equal 3, AccessContext::Permission.permissions.count
    assert_equal 3, AccessContext::Permission.all.count
  end

end
