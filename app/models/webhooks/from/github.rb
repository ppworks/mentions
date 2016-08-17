class Webhooks::From::Github < Webhooks::From::Base
  PATTERNS = %w(comment pull_request issue)
  ACCEPT_ACTIONS = %w(created opened assigned edited)

  def comment
    assigned? ? 'assigned' : search_content('body')
  end

  def from
    "#{sender}@github"
  end

  def id
    opened? ? [@payload.dig('pull_request', 'number')].compact.first : [@payload.dig('issue', 'number')].compact.first
  end

  def icon_url
    [@payload.dig('sender', 'avatar_url')].compact.first
  end

  def sender
    [@payload.dig('sender', 'login')].compact.first
  end

  def action
    @payload['action']
  end

  def summary
    "you've been mention by #{action} from #{sender}"
  end

  def title
    search_content('title')
  end

  def url
    search_content('html_url')
  end

  def body
    assigned? ? nil : search_content('body')
  end

  def mentions
    if assigned?
      [@payload.dig('assignee', 'login')].compact
    else
      super
    end
  end

  def assigned?
    @payload.dig('action') == 'assigned'
  end

  def opened?
    @payload.dig('action') == 'opened'
  end

  def accept?
    ACCEPT_ACTIONS.include?(action)
  end
end
