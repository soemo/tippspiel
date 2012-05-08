module RankingHelper

  # schreibt die Rankingtabelle
  # solange das Turnier noch nicht begonnen hat, wird nichts angezeigt
  def write_ranking_table(user_hash, short=false)
    unless before_tournament?
      haml_tag "table.table.table-striped.table-condensed.ranking" do
        haml_tag :thead do
          haml_tag :tr do
            haml_tag :th, t("standings")
            haml_tag :th, "<i class='icon-signal'></i>".html_safe unless short
            haml_tag :th, User.human_attribute_name("name")
            haml_tag :th, Game.human_attribute_name("siegertipp") unless short
            haml_tag :th,Game.human_attribute_name("points") unless short
          end
        end
        haml_tag :thead do
          user_hash.each do |place, users_on_same_place|
            users_on_same_place.each do |user|
              haml_tag "tr.#{cycle('even', 'odd')}" do
                haml_tag :td, place
                haml_tag :td, "to do link" unless short
                haml_tag :td, user.name
                haml_tag :td, before_tournament? ? "" : user.championtipp_team unless short
                haml_tag :td, statistic_point_popover_link(user) unless short
              end
            end
          end
        end
      end
    end

  end

  def statistic_point_popover_link(user, css_class ="statistic_popover")
    if user.present?
      content = statistik_tooltip(user)
      title = "Punkteverteilung"
      user_points = user.points.present? ? user_points.to_s : "0"
      link_to(user_points, "#",
              {:class => css_class, :rel => "popover", "data-content" => content,
              "data-original-title" => title})
    end
  end

  def statistik_tooltip(user)
    temp = []
    temp << "#{user.name}"
    temp << "#{user.count6points.present? ? user.count6points : 0} x 6 Punkte"
    temp << "#{user.count4points.present? ? user.count6points : 0} x 4 Punkte"
    temp << "#{user.count3points.present? ? user.count6points : 0} x 3 Punkte"
    temp << "#{user.count0points.present? ? user.count6points : 0} x 0 Punkte"
    temp << "Punkte Siegertipp: #{user.championtipppoints}"
    temp.join("<br/>")
  end
end
