class SidebarNotesCell < Cell::Rails
  # Caching so lange, bis ein neuer Kommentar vorhanden ist
  cache :show do |options|
    options[:last_updated_at].to_i
  end

  def show(args)
    item_count    = args[:item_count]
    @notes        = Notice.limit(item_count).all #FIXME soeren 06.09.2014 .all ?

    render
  end

end
