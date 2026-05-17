# frozen_string_literal: true

class BaseService
  include Virtus.model

  def self.call(*)
    new(*).call
  end
end
