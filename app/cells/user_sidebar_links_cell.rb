class UserSidebarLinksCell < Cell::Rails
  #aktuell kein Caching

  def show(args)
    @current_user = args[:user]
    render
  end

end
