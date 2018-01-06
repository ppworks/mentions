class Webhooks::From::Base
  PATTERNS = %w()

  attr_reader :payload

  def initialize(payload:)
    @payload = JSON.parse(payload)
  end

  def comment
    ''
  end

  def url
    ''
  end

  def mentions
    return [] unless comment
    comment.scan(/@([\S]+)/).flatten.uniq || []
  end

  def additional_message
    "you've been mentioned"
  end

  def accept?
    true
  end

  private

  def search_content(*keys)
    self.class::PATTERNS.map { |pattern| @payload.dig(*[pattern, *keys]) }.compact.first
  end
end
