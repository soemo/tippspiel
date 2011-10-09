module ApplicationHelper

  def main_nav
    [
      ["home", root_path],
      ["help", help_index_path]
    ]

  end

end
