class HttpPostJob < ApplicationJob
  def perform(uri, params)
    require 'net/http'
    Net::HTTP.post_form(URI.parse(uri), params)
  end
end
