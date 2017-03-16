module Querii
  module QueryObject
    def self.included(base)
      base.extend ClassMethods

      base.class_eval do
        # dynamically defines a base Scopes module
        self.const_set(:Scopes, Module.new)
        default_scope { all }
      end
    end

    module ClassMethods
      # optionally override the default determined by top level namespace
      attr_accessor :model_name

      def call(*args, relation: base_class.all, **kargs)
        relation.extending(self::Scopes).default(*args, **kargs)
      end

      alias_method :all, :call

      def scope(name, body, &block)
        unless body.respond_to?(:call)
          raise ArgumentError, 'The scope body needs to be callable.'
        end

        self::Scopes.send(:define_method, name) do |*args, **kargs|
          # unfortunately empty double splatted kargs still count as arguments
          # for a lambda's argument arity checking
          if kargs.empty?
            scope = all.scoping { instance_exec(*args, &body) }
          else
            scope = all.scoping { instance_exec(*args, **kargs, &body) }
          end

          scope || all
        end
      end

      def default_scope(scope = nil)
        scope = Proc.new if block_given?
        scope(:default, scope)
      end

      # queries are namespaced by plural model name
      # from which we can infer query base model
      def base_class
        klass = model_name || self.to_s.split('::').first.singularize
        klass.to_s.constantize
      end
      private :base_class

    end
  end
end
