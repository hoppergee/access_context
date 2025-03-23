class AccessContext
  class Role

    class << self
      def grant(role_name, permission_names)
        name = role_name.to_sym
        role = roles[name]
        if role
          role.add_permissions(permission_names)
        else
          roles[name] = new(name, permission_names)
        end
      end

      def [](role)
        if role.is_a?(Role)
          role
        else
          roles[role.to_sym]
        end
      end

      def all
        roles
      end

      def roles
        @roles ||= {}
      end
    end

    attr_reader :name, :permission_names

    def initialize(name, permission_names)
      @name = name
      @permission_names = (permission_names || []).map(&:to_sym).uniq
    end

    def add_permissions(names)
      symbolized_names = (names || []).map(&:to_sym)
      @permission_names = (@permission_names + symbolized_names).uniq
    end

    def permissions
      @permissions ||= permission_names.map do |permission_name|
        AccessContext::Permission.all[permission_name]
      end.compact
    end

  end
end