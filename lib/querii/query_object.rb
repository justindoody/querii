module Querii
  module QueryObject
    def self.included(base)
      base.extend ClassMethods

      base.class_eval do
        # dynamically defines a base Scopes module
        self.const_set(
          :Scopes,
          Module.new do
            def applied(*args, **key_args)
              all
            end
          end
        )
      end
    end

    module ClassMethods
      def call(*args, relation: default_relation_all, **key_args)
        relation.extending(self::Scopes).applied(args, key_args)
      end

      def default_relation_all
        # .all returns current scope || all
        relation_base.all
      end

      # queries are namespaced by plural model name
      # from which we can infer query base model
      def relation_base
        default_relation.to_s.constantize || self.to_s.split('::').first.singularize.constantize
      end

      alias_method :all, :call

      attr_accessor :default_relation
    end
  end
end
