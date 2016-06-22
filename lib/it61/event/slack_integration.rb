require 'slack-notifier'

class Event::SlackIntegration
  include ApplicationHelper
  include Rails.application.routes.url_helpers

  def self.instance
    @__instance__ ||= new
  end

  def self.notify(event)
    instance.notify_slack(event)
  end

  def notify_slack(event)
    attachment = build_attachment(event)
    notifier.ping I18n.t('slack_integration.new_event'), attachments: [attachment]
  end

  def self.send_invite(email)
    token = ENV['SLACK_TOKEN']
    row_uri = ENV['SLACK_INVITE_URL']

    uri = URI.parse(row_uri)
    res = Net::HTTP.post_form(uri, email: email, token: token)

    case res
    when Net::HTTPOK
      jsonRes = JSON.parse(res.body)
      was_sent = jsonRes['ok']
      error = jsonRes['error']
      {
        success: was_sent,
        error: error
      }
    else
      {
        success: false,
        error: res
      }
    end
  end

  private

  def notifier
    @notifier ||= Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'])
  end

  def build_attachment(event)
    text = plain_text(event.description)
    {
      title: event.title,
      title_link: event_url(event),
      thumb_url: event.title_image.url(:square_500),
      text: text,
      fallback: text,
      color: :good,
      fields: [
        {
          title: Event.human_attribute_name(:place),
          value: event.place,
          short: true
        },
        {
          title: Event.human_attribute_name(:started_at),
          value: I18n.l(event.started_at, format: :date_time_full),
          short: true
        }
      ]
    }
  end
end
