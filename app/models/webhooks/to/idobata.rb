class Webhooks::To::Idobata
  def initialize(mention:, from:, icon_url:, summary:, title:, url:, body:)
    @mention = "@#{mention}"
    @text = "#{@mention} #{url} #{summary}"
    # TODO: support multiple hook
    @webhook_uri = ENV.fetch('IDOBATA_WEBHOOK_URL')
  end

  def post
    HttpPostJob.perform_later(@webhook_uri, { source: @text })
  end
end
