module ApplicationHelper

  def humanize_date(date)
    human_date = "#{I18n.l(date, format: :day_in_words)}, "
    human_date << "#{ActiveSupport::Inflector.ordinalize(date.day)} "
    human_date << I18n.l(date, format: :month)
  end

  def humanize_date_with_time(date, time=date)
    human_date = humanize_date(date)
    human_date << " at #{I18n.l(time, format: :time)}"
  end

  def dot_markdown(text)
    GitHub::Markdown.render_gfm(text).html_safe
  end

  def belongs_to_group? group
    current_user.groups.include?(group)
  end

  def can_access?(resource)
    current_user.has_role?(:admin) or current_user.has_role?(:organiser) or current_user.has_role?(:organiser, resource)
  end

  def has_permission?
    current_user.has_role?(:admin) or current_user.has_role?(:organiser) or Chapter.find_roles(:organiser, current_user).any?
  end

  def member_token(member)
    require 'verifier'
    Verifier.new(id: member.id).access_token
  end

  def twitter
    Planner::Application.config.twitter
  end

  def twitter_id
    Planner::Application.config.twitter_id
  end

  def contact_email
    @contact_email ||= @session.present? ? @session.chapter.email : "hello@codebar.io"
  end

  def redirect_if_complete
    if current_user.received_coach_welcome_email || current_user.received_student_welcome_email
      profile_path
    else
      flash[:error] = 'Please subscribe to at least one group before continuing.'
      step2_member_path
    end
  end
end
