module Munson
  module RSpec
    module Macros
      module ModelMacros
        def spawn_model(klass, options={}, &block)
          super_class = options[:super_class]
          new_class = if super_class
                        Class.new(super_class)
                      else
                        Class.new
                      end
          if klass =~ /::/
            base, submodel = klass.split(/::/).map{ |s| s.to_sym }
            Object.const_set(base, Module.new) unless Object.const_defined?(base)
            Object.const_get(base).module_eval do
              remove_const submodel if constants.map(&:to_sym).include?(submodel)
              submodel = const_set(submodel, new_class)
              submodel.send(:include, Munson::Resource)
              submodel.class_eval(&block) if block_given?
            end

            @spawned_models << base
          else
            Object.instance_eval { remove_const klass } if Object.const_defined?(klass)
            Object.const_set(klass, Class.new).send(:include,  Munson::Resource)
            Object.const_get(klass).class_eval(&block) if block_given?

            @spawned_models << klass.to_sym
          end
        end
      end
    end
  end
end
