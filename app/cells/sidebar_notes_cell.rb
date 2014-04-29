class SidebarNotesCell < Cell::Rails
  # Caching so lange, bis ein neuer Kommentar vorhanden ist
  cache :show do |options|
    options[:last_updated_at].to_i
  end

  def show(args)
    Rails.logger.info("test sm in SidebarNotesCell Start") # FIXME soeren 29.04.14 wieder raus
    @current_user = args[:user]
    item_count    = args[:item_count]
    @notes        = Notice.limit(item_count).all
    Rails.logger.info("test sm in SidebarNotesCell End") # FIXME soeren 29.04.14 wieder raus
    render
  end

end
