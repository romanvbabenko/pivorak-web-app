# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  PIVORAK_EMAIL = 'pivorak.me@gmail.com'
  NO_REPLY_EMAIL = 'no-reply@pivorak.com'
  default from: PIVORAK_EMAIL
  layout 'mailer'
  default template_path: ->(mailer) { "mailers/#{mailer.class.name.underscore}" }

  def email_template
    @email_template ||= EmailTemplate.find_by!(title: "#{self.class}##{action_name}")
  end
end
