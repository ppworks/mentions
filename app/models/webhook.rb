class Webhook < ApplicationRecord
  FROM = %w(github esa)
  TO = %w(slack)

  validates :from, inclusion: { in: FROM }
  validates :to, inclusion: { in: TO }
  validates :token, uniqueness: true

  def from_class
    Webhooks::From.const_get(from.classify)
  end

  def to_class
    Webhooks::To.const_get(to.classify)
  end

  def run(payload:)
    from_instance = from_class.new(payload: payload)
    mentions = from_instance.mentions.map { |m|
      id_mapping ||= IdMapping.new(ENV['MENTIONS_MAPPING_FILE_PATH'])
      id_mapping.find(user_name: m, from: from, to: to)
    }.compact
    to_class.new(mentions: mentions, url: from_instance.url).run
  end
end
