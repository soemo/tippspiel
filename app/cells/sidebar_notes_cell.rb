class SidebarNotesCell < Cell::Rails
  # Caching so lange, bis ein neuer Kommentar vorhanden ist
  cache :show do |options|
    options[:last_updated_at].to_i
  end

  def show(args)
    item_count    = args[:item_count]
    @notes        = NoticeQueries.order_by_created_at_asc.limit(item_count)

    render
  end

end
