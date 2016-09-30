class Webhook < ApplicationRecord
  FROM = %w(trello github esa bitbucket)
  TO = %w(slack idobata)

  validates :from, inclusion: { in: FROM }
  validates :to, inclusion: { in: TO }
  validates :token, uniqueness: true

  before_validation :set_token, on: :create, unless: -> { token }

  class << self
    def new_by_token(token)
      if webhook_attributes = tokens_in_env.find { |w| w[:token] == token }
        Webhook.new(webhook_attributes)
      end
    end

    private

    def tokens_in_env
      FROM.map { |f| TO.map { |t| {from: f, to: t, token: token_in_env(f, t)} } }.flatten
    end

    def token_in_env(from, to)
      ENV.fetch("#{from.upcase}_TO_#{to.upcase}_TOKEN", nil)
    end
  end

  def from_class
    Webhooks::From.const_get(from.classify)
  end

  def to_class
    Webhooks::To.const_get(to.classify)
  end

  def run(payload:)
    from_instance = from_class.new(payload: payload)
    return unless from_instance.accept?

    mentions = from_instance.mentions.map { |m|
      id_mapping ||= IdMapping.new(ENV.fetch('MENTIONS_MAPPING_FILE_PATH'))
      id_mapping.find(user_name: m, from: from, to: to)
    }.compact

    mentions.uniq.each do |mention|
      to_class.new(mention: mention, from: from_instance.from, id: from_instance.id, icon_url: from_instance.icon_url, summary: from_instance.summary, title: from_instance.title, url: from_instance.url, body: from_instance.body).post
    end
  end

  private

  def set_token
    self.token = SecureRandom.uuid.gsub(/-/,'')
  end
end
