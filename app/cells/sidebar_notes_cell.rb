class SidebarNotesCell < Cell::Rails
  # Caching so lange, bis ein neuer Kommentar vorhanden ist
  #cache :show## FIXME soeren 29.04.14 , :tags => lambda { |*args| tags }

  def show(args)
    @current_user = args[:user]
    item_count   = args[:item_count]
    @notes        = Notice.limit(item_count).all

    render
  end

end
