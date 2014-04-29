class SidebarNotesCell < Cell::Rails
  # Caching so lange, bis ein neuer Kommentar vorhanden ist
  cache :show do |options|
    options[:last_updated_at].to_i
  end

  def show(args)
    @current_user = args[:user]
    item_count    = args[:item_count]
    @notes        = Notice.limit(item_count).all

    render
  end

end
