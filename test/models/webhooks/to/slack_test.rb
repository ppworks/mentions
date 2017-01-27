require 'test_helper'

class Webhooks::To::SlackTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  def test_run
    mention = 'ppworks'
    from = 'johndoe'
    id = '1'
    icon_url = 'http://icon.example.com'
    url = 'http://example.com'
    summary = 'summary'
    title = 'title'
    body = 'message'

    slack = Webhooks::To::Slack.new(mention: mention, from: from, id:id, icon_url:icon_url, summary:summary, title:title, url: url, body: body)

    assert_enqueued_with(job: HttpPostJob) do
      slack.post
    end

    assert_equal "@#{mention}", slack.instance_variable_get(:@channel)
    assert_enqueued_jobs 1
  end

  def test_run_everyone
    mention = 'everyone'
    from = 'johndoe'
    id = '1'
    icon_url = 'http://icon.example.com'
    url = 'http://example.com'
    summary = 'summary'
    title = 'title'
    body = 'message'

    slack = Webhooks::To::Slack.new(mention: mention, from: from, id:id, icon_url:icon_url, summary:summary, title:title, url: url, body: body)
    assert_enqueued_with(job: HttpPostJob) do
      slack.post
    end

    assert_equal '#general', slack.instance_variable_get(:@channel)
    assert_enqueued_jobs 1
  end
end
