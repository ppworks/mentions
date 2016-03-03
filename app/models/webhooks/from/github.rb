class Webhooks::From::Github
  attr_reader :payload

  def initialize(payload:)
    @payload = JSON.parse(payload)
  rescue
    @payload = nil
  end

  def comment
    # 雑に探す
    @payload['pull_request']['body']
  rescue
    @payload['comment']['body']
  end

  def url
    # 雑に探す
    @payload['pull_request']['html_url']
  rescue
    @payload['comment']['html_url']
  end

  def mentions
    comment.match(/@([\S]+)/).to_a[1..-1] || []
  end
end
