module Admin
  class BaseController < ApplicationController

    around_action :do_if_allowed?

    private

    def do_if_allowed?
      if current_user.admin?
        yield
      else
        render text:  '403 forbidden', status: :forbidden
      end
    end

  end
end