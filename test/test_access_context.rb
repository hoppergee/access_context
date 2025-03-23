# frozen_string_literal: true

require "test_helper"

class TestAccessContext < ApplicationTest

  def test_that_it_has_a_version_number
    refute_nil ::AccessContext::VERSION
  end

  def test_initialize
    context = AccessContext.new("controller", "Users", "new")
    assert_equal :controller, context.type
    assert_equal :Users, context.name
    assert_equal :new, context.target
  end

  def test_contains
    c = ->(type, name, target = nil) { AccessContext.new(type, name, target) }
    assert c.("controller", "Users", "new").contains?(c.("controller", "Users", "new"))
    assert c.(:controller, :Users, :new).contains?(c.("controller", "Users", "new"))
    refute c.(:controller, :Users, :new).contains?(c.(:controller, :Users, :show))
    refute c.(:controller, :Users, :new).contains?(c.(:controller, :Orders, :new))
    refute c.(:controller, :Users, :new).contains?(c.(:service, :Users, :new))

    assert c.(:controller, "admin/products").contains?(c.(:controller, "admin/products", :new))
  end

  def test_permit_role
    refute AccessContext.new(:controller, "admin/dashboard", :show).permit_role?("support")
    assert AccessContext.new(:controller, "admin/dashboard", :show).permit_role?("admin")
    refute AccessContext.new(:controller, "admin/dashboard", :show).permit_role?(AccessContext::Role["support"])
    assert AccessContext.new(:controller, "admin/dashboard", :show).permit_role?(AccessContext::Role["admin"])

    assert AccessContext.new(:controller, :home, :show).permit_role?("support")
    assert AccessContext.new(:controller, :home, :show).permit_role?("admin")
    assert AccessContext.new(:controller, :home, :show).permit_role?(AccessContext::Role["support"])
    assert AccessContext.new(:controller, :home, :show).permit_role?(AccessContext::Role["admin"])

    refute AccessContext.new(:controller, :home, :other).permit_role?("support")
    refute AccessContext.new(:controller, :home, :other).permit_role?("admin")
    refute AccessContext.new(:controller, :home, :other).permit_role?(AccessContext::Role["support"])
    refute AccessContext.new(:controller, :home, :other).permit_role?(AccessContext::Role["admin"])

    assert AccessContext.new(:service, :visit, :call).permit_role?("admin")
    assert AccessContext.new(:service, :visit, :call).permit_role?("support")
    assert AccessContext.new(:service, :visit, :call).permit_role?(AccessContext::Role["admin"])
    assert AccessContext.new(:service, :visit, :call).permit_role?(AccessContext::Role["support"])

    assert AccessContext.new(:job, :welcome, :perform).permit_role?("admin")
    assert AccessContext.new(:job, :welcome, :perform).permit_role?("support")
    assert AccessContext.new(:job, :welcome, :perform).permit_role?(AccessContext::Role["admin"])
    assert AccessContext.new(:job, :welcome, :perform).permit_role?(AccessContext::Role["support"])

    assert AccessContext.new(:controller, "admin/orders", :show).permit_role?("admin")
    refute AccessContext.new(:controller, "admin/orders", :show).permit_role?("support")
    assert AccessContext.new(:controller, "admin/orders", :show).permit_role?(AccessContext::Role["admin"])
    refute AccessContext.new(:controller, "admin/orders", :show).permit_role?(AccessContext::Role["support"])
  end

  def test_permit
    refute AccessContext.new(:controller, "admin/dashboard", :show).permit?(OpenStruct.new(role: "support"))
    assert AccessContext.new(:controller, "admin/dashboard", :show).permit?(OpenStruct.new(role: "admin"))

    assert AccessContext.new(:controller, :home, :show).permit?(OpenStruct.new(role: "support"))
    assert AccessContext.new(:controller, :home, :show).permit?(OpenStruct.new(role: "admin"))

    refute AccessContext.new(:controller, :home, :other).permit?(OpenStruct.new(role: "support"))
    refute AccessContext.new(:controller, :home, :other).permit?(OpenStruct.new(role: "admin"))
  end

end
