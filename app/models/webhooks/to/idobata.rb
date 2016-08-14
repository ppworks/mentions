class Webhooks::To::Idobata
  def initialize(mention:, title:, url:, additional_message:)
    @mention = "@#{mention}"
    @text = "#{@mention} #{url} #{additional_message}"
    # TODO: support multiple hook
    @webhook_uri = ENV.fetch('IDOBATA_WEBHOOK_URL')
  end

  def post
    HttpPostJob.perform_later(@webhook_uri, { source: @text })
  end
end
