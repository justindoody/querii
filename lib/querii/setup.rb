module Querii
  module Setup
    extend ActiveSupport::Concern

    class_methods do
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
        @_relation_base ||= self.to_s.split('::').first.singularize.constantize
      end

      alias_method :all, :call
    end

    # dynamically defines a base Scopes module
    included do
      scopes_base = Module.new do
        def applied(*args, **key_args)
          all
        end
      end

      self.const_set(:Scopes, scopes_base)
    end
  end
end
