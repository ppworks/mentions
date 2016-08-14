class Webhooks::From::Github < Webhooks::From::Base
  PATTERNS = %w(comment pull_request issue)
  ACCEPT_ACTIONS = %w(created opened assigned)

  def comment
    assigned? ? 'assigned' : search_content('body')
  end

  def from
    "#{sender}@github"
  end

  def icon_url
    [@payload.dig('sender', 'avatar_url')].compact.first
  end

  def sender
    [@payload.dig('sender', 'login')].compact.first
  end

  def summary
    assigned? ? "you've been assigned by #{sender}" : "you've been mentioned from #{sender}"
  end

  def title
    search_content('title')
  end

  def url
    search_content('html_url')
  end

  def mentions
    if assigned?
      [@payload.dig('assignee', 'login')].compact
    else
      super
    end
  end

  def body
    assigned? ? nil : search_content('body')
  end

  def assigned?
    @payload.dig('action') == 'assigned'
  end

  def accept?
    ACCEPT_ACTIONS.include?(@payload['action'])
  end
end
