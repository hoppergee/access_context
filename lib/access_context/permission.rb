class AccessContext
  class Permission

    class << self
      def grant(name, &block)
        permissions[name.to_sym] = new(name, &block)
      end

      def all
        permissions
      end

      def permissions
        @permissions ||= {}
      end
    end

    def initialize(name, &block)
      @name = name.to_sym
      instance_eval(&block)
    end

    def permit?(context)
      contexts.any? do |c|
        c == context
      end
    end

    def context(type, name, targets=[])
      (targets || []).each do |target|
        contexts << AccessContext.new(type, name, target)
      end
    end

    def controller(name, actions=[])
      (actions || []).each do |action|
        contexts << AccessContext.controller(name, action)
      end
    end

    def service(name, actions=[])
      (actions || []).each do |action|
        contexts << AccessContext.service(name, action)
      end
    end

    def view(name, elements=[])
      (elements || []).each do |element|
        contexts << AccessContext.service(name, element)
      end
    end

    def job(name, actions=[])
      (actions || []).each do |action|
        contexts << AccessContext.job(name, action)
      end
    end

    def contexts
      @contexts ||= []
    end
  end
end