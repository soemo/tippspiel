# -*- encoding : utf-8 -*-
module RankingHelper

  # schreibt die Rankingtabelle
  def write_ranking_table(user_ranking, short=false)
    haml_tag 'table.ranking' do
      haml_tag :thead do
        haml_tag :tr do
          haml_tag :th, t('standings')
          haml_tag :th, User.human_attribute_name('name')
          haml_tag :th, Game.human_attribute_name('siegertipp') unless short
          haml_tag :th, User.human_attribute_name('points')
          haml_tag :th, I18n.t(:points_statistic) unless short
      end
      haml_tag :tbody do
        user_ranking.each do |place, users_on_same_place|
          users_on_same_place.each_with_index do |user, index|
            # vor dem Tunier soll in der Kurzform nur 3 Zeilen angezeigt werden
            next if index > 3 && short.present? && Tournament.not_yet_started?
            haml_tag :tr do
              haml_tag 'td.place', place
              haml_tag :td, user.name
              haml_tag :td, Tournament.not_yet_started? ? '' : user.championtip_team unless short
              haml_tag :td, user.points.present? ? user.points.to_s : '0'
              haml_tag :td do
                haml_concat statistic_content(user)
              end unless short
              end

            end
          end
        end
      end
    end
    if short.present?
      haml_tag :p do
        haml_concat link_to(t('full_ranking_list'), ranking_path)
      end
    end
  end


  def statistic_content(user)
    result = ''

    if user.present?
      POINTS_TO_CSS_CLASS.each do |key, css_class|
        count = user.send("count#{key}points")
        count = count.present? ? count : 0
        result << pointbadge_with_content(count, css_class, "#{key} #{User.human_attribute_name('points')}")
      end

      champion_tippoints = user.championtippoints
      champion_tippoint_title = "#{User.human_attribute_name('points')} #{User.human_attribute_name('siegertipp')}: #{champion_tippoints}"
      css_class = POINTS_TO_CSS_CLASS["#{champion_tippoints}"]
      result << '&nbsp;&nbsp'
      result << pointbadge_with_content(icon('trophy'), css_class, champion_tippoint_title)
    end
    # FIXME soeren 3/13/16 spec anpassen
    result
  end
end
