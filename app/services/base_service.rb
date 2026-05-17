# frozen_string_literal: true

class BaseService
  # Declares keyword attributes for the service.
  # Defines attr_readers and records names so initialize can assign them.
  def self.attribute(*names)
    attr_reader(*names)

    @_attributes ||= []
    @_attributes.concat(names.map(&:to_sym))
  end

  # Collects attribute names from the full ancestor chain so subclasses of
  # subclasses (e.g. UserBaseService subclasses) inherit all attributes.
  def self.attributes
    ancestors.grep(Class).reverse
             .flat_map { |klass| klass.instance_variable_get(:@_attributes) || [] }
             .uniq
  end

  def self.call(...)
    new(...).call
  end

  def initialize(**kwargs)
    self.class.attributes.each do |name|
      instance_variable_set(:"@#{name}", kwargs[name])
    end
  end
end
