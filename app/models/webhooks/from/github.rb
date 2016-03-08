class Webhooks::From::Github
  attr_reader :payload

  def initialize(payload:)
    @payload = payload
  rescue
    @payload = {}
  end

  def comment
    # 雑に探す
    @payload.dig('comment', 'body') \
    || @payload.dig('pull_request', 'body')
  end

  def url
    # 雑に探す
    @payload.dig('comment', 'html_url') \
    || @payload.dig('pull_request', 'html_url')
  end

  def mentions
    comment.match(/@([\S]+)/).to_a[1..-1] || []
  end
end
