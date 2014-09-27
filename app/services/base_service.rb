# -*- encoding : utf-8 -*-
module BaseService
  extend ActiveSupport::Concern

  included do
    def self.call(*args)
      new(*args).call
    end
  end
end