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
        end
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
              haml_tag :td do
                haml_concat statistic_hover_dropdown_link(user)
                haml_concat statistic_hover_dropdown_content(user)
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

  def statistic_hover_dropdown_link(user)
    if user.present?

      user_points = user.points.present? ? user.points.to_s : '0'

      link_to(user_points, '#', {data: {dropdown: get_dropdown_id(user.id), options: 'is_hover:true; align:left'}})
    end
  end

  def get_dropdown_id(user_id)
    "statistik_#{user_id}"
  end

  def statistic_hover_dropdown_content(user)
    result = ''
    if user.present?
      result << "<div id='#{get_dropdown_id(user.id)}' data-dropdown-content class='f-dropdown content' aria-hidden='true' tabindex='-1'>"
      result << "<div class='text-right'><b>#{user.name}</br>"
      result << "#{I18n.t('points_statistic')}</b></br>"

      temp   = {'8' => user.count8points,
                '5' => user.count5points,
                '4' => user.count4points,
                '3' => user.count3points,
                '0' => user.count0points}
      temp.each do |key, count|
        count = count.present? ? count : 0
        result << "#{count} x #{key} #{User.human_attribute_name('points')}</br>"
      end
      result << "#{User.human_attribute_name('points')} #{User.human_attribute_name('siegertipp')}: #{user.championtippoints}"

      result << '</div></div>'
    end
    result
  end
end
