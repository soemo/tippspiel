class NavBarItemPresenter

  attr_reader :link_icon_prefix, :link_icon, :link_text, :link_url, :css_class

  def initialize(link_icon_prefix, link_icon, link_text, link_url, css_class)
    @link_icon_prefix = link_icon_prefix
    @link_icon        = link_icon
    @link_text        = link_text
    @link_url         = link_url
    @css_class        = css_class
  end
end
