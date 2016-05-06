class NavBarItemPresenter

  attr_reader :link_text, :link_url, :sub_menu_id, :sub_menu_links, :css_class

  def initialize(link_text, link_url, sub_menu_id, sub_menu_links, css_class)
    @link_text      = link_text
    @link_url       = link_url
    @sub_menu_id    = sub_menu_id
    @sub_menu_links = sub_menu_links
    @css_class      = css_class
  end

  def has_sub_menu?
    sub_menu_id.present?
  end

end
