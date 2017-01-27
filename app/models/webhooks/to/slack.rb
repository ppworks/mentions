class Webhooks::To::Slack
  def initialize(mention:, from:, id:, icon_url:, summary:, title:, url:, body:)
    @mention = "@#{mention}"
    @channel = @mention == '@everyone' ? '#general' : @mention
    @from = from
    @summary = "<#{url}|#{id}>: #{summary}"
    @title = title
    @url = url
    @icon_url = icon_url
    @body = body
    @webhook_uri = ENV.fetch('SLACK_WEBHOOK_URL')
  end

  def post

    payload = {
        username: @from,
        icon_url: @icon_url,
        text: @summary,
        attachments: [
            {
                title: @title,
                title_link: @url,
                text: @body,
                mrkdwn_in: ["text"]
            }
        ],
        link_names: 1,
        channel: @channel
    }
    HttpPostJob.perform_later(@webhook_uri, { payload: payload.to_json })
  end
end
