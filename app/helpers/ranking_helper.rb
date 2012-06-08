module RankingHelper

  # schreibt die Rankingtabelle
  def write_ranking_table(user_ranking, short=false)
    haml_tag "table.table.table-striped.table-condensed.ranking" do
      haml_tag :thead do
        haml_tag :tr do
          haml_tag :th, t("standings")
          haml_tag :th do
            ## FIXME soeren 11.05.12 einblenden wenn Statistic soweit ist haml_concat "<i class='icon-signal'></i>".html_safe unless short
            haml_concat User.human_attribute_name("name")
          end
          haml_tag :th, Game.human_attribute_name("siegertipp") unless short
          haml_tag :th,Game.human_attribute_name("points") unless short
        end
      end
      haml_tag :tbody do
        user_ranking.each do |place, users_on_same_place|
          users_on_same_place.each_with_index do |user, index|
             # vor dem Tunier soll in der Kurzform nur 3 Zeilen angezeigt werden oder wenn die User noch 0 Punkte haben
            next if index > 3 && short.present? && (before_tournament? || user.points == 0)
            haml_tag "tr.#{cycle('even', 'odd')}" do
              haml_tag :td, place
              haml_tag :td do
                if short
                  haml_concat user.name
                else
                  haml_concat user.name
                  ## FIXME soeren 11.05.12 einblenden wenn Statistic soweit ist haml_concat link_to(user.name, user_statistic_path(:id => user.id), "data-toggle"=>"modal")
                end
              end
              haml_tag :td, before_tournament? ? "" : user.championtipp_team unless short
              haml_tag :td, statistic_point_popover_link(user) unless short
            end
          end
        end
      end
    end
    if short.present?
      haml_tag :p do
        haml_concat link_to(t("full_ranking_list"), ranking_path)
      end
    end
  end

  def statistic_point_popover_link(user, css_class ="statistic_popover")
    if user.present?
      content = statistik_tooltip(user)
      title = user.name
      user_points = user.points.present? ? user.points.to_s : "0"
      link_to(user_points, "#",
              {:class => css_class, :rel => "popover", "data-content" => content,
              "data-original-title" => title})
    end
  end

  def statistik_tooltip(user)
    temp = []
    temp << "<b>#{I18n.t('points_statistic')}</b>".html_safe
    temp << "#{user.count6points.present? ? user.count6points : 0} x 6 Punkte"
    temp << "#{user.count4points.present? ? user.count4points : 0} x 4 Punkte"
    temp << "#{user.count3points.present? ? user.count3points : 0} x 3 Punkte"
    temp << "#{user.count0points.present? ? user.count0points : 0} x 0 Punkte"
    temp << "Punkte Siegertipp: #{user.championtipppoints}"
    temp.join("<br/>")
  end
end
