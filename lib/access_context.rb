# frozen_string_literal: true

require_relative "access_context/version"
require 'active_support/dependencies/autoload'
require 'active_support/core_ext'

class AccessContext

  class Error < StandardError; end

  autoload :Configuration, 'access_context/configuration'
  autoload :Permission,    'access_context/permission'
  autoload :Role,          'access_context/role'

  class << self

    def config(&block)
      Configuration.module_eval(&block)
    end

    def controller(name, target)
      AccessContext.new(:controller, name, target)
    end

    def service(name, target)
      AccessContext.new(:service, name, target)
    end

    def view(name, target)
      AccessContext.new(:view, name, target)
    end

    def job(name, target)
      AccessContext.new(:job, name, target)
    end

  end

  attr_reader :type, :name, :target

  def initialize(type, name, target=nil)
    @type = type.to_sym
    @name = name.to_sym
    @target = target&.to_sym
  end

  def permit?(user)
    permit_role?(user.role)
  end

  def permit_role?(role)
    AccessContext::Role[role].permissions.any? do |permission|
      permission.permit?(self)
    end
  end

  def contains?(context)
    type == context.type &&
    name == context.name &&
    (
      target == context.target ||
      target.blank?
    )
  end

end
