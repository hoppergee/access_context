class AccessContext
  module Configuration
    module_function

    def roles(&block)
      Role.class_eval(&block)
    end

    def permissions(&block)
      Permission.class_eval(&block)
    end
  end
end