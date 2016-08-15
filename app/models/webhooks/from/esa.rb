class Webhooks::From::Esa < Webhooks::From::Base
  PATTERNS = %w(comment post)

  def comment
    search_content('body_md')
  end

  def url
    @payload.dig('post', 'url')
  end

  def mentions
    return [] unless @payload.dig('kind') =~ /_mention\z/
    [@payload.dig('mentioned_user', 'screen_name')].compact
  end

  def summary
    "you've been mentioned(\\( ⁰⊖⁰)/)"
  end
end
