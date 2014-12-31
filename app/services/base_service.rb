# -*- encoding : utf-8 -*-
class BaseService

  include Virtus.model

  def self.call(*args)
    new(*args).call
  end
end