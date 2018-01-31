module Reality
  module Miracles
    module EntityMethods
      extend Memoist

      def method_missing(name, *arg, &block)
        super if !arg.empty? && block.nil? && _symbolic_names.key?(name)
        _symbolic_names.fetch(name)
      end

      def respond_to_missing?(name, *)
        _symbolic_names.key?(name)
      end

      private

      memoize def _symbolic_names
        observations.group_by { |o| nameify(o.variable) }.to_h
      end

      def nameify(name)
        # TODO: Something(s) => somethings
        name.downcase.gsub(/\([^)]+\)/, '').gsub(/[^a-z_0-9]/, '_').sub(/(^_+|_+$)/, '').to_sym
      end
    end

    module LinkMethods
      extend Memoist

      def method_missing(name, *arg, &block)
        entity.method_missing(name, *arg, &block)
      end

      def respond_to_missing?(name, *)
        entity.respond_to?(name)
      end

      private

      memoize def entity
        load
      end
    end
  end

  Entity.prepend Miracles::EntityMethods
  Link.prepend Miracles::LinkMethods
end
