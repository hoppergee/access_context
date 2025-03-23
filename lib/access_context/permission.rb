class AccessContext
  class Permission

    class << self
      def grant(name, &block)
        permissions[name.to_sym] = new(name, &block)
      end

      def [](name)
        permissions[name.to_sym]
      end

      def all
        permissions
      end

      def permissions
        @permissions ||= {}
      end
    end

    attr_reader :name

    def initialize(name, &block)
      @name = name.to_sym
      instance_eval(&block)
    end

    def permit?(context)
      contexts.any? do |c|
        c.contains?(context)
      end
    end

    def context(type, name, targets=[])
      if targets.present?
        ([targets] || []).flatten.each do |target|
          contexts << AccessContext.new(type, name, target)
        end
      else
        contexts << AccessContext.new(type, name)
      end
    end

    def controller(name, actions=[])
      context(:controller, name, actions)
    end

    def service(name, actions=[])
      context(:service, name, actions)
    end

    def view(name, elements=[])
      context(:view, name, elements)
    end

    def job(name, actions=[])
      context(:job, name, actions)
    end

    def contexts
      @contexts ||= []
    end
  end
end