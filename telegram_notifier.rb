require 'net/http'
require 'uri'
require 'json'

class TelegramNotifier
  TELEGRAM_API_URL = "https://api.telegram.org"

  def initialize
    @bot_token = ENV['TELEGRAM_BOT_TOKEN']
    @group_id = ENV['GROUP_ID']
    raise "Missing TELEGRAM_BOT_TOKEN or GROUP_ID" unless @bot_token && @group_id
  end

  def send_message(message)
    uri = URI.parse("#{TELEGRAM_API_URL}/bot#{@bot_token}/sendMessage")
    params = {
      chat_id: @group_id,
      text: message
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri, { 'Content-Type' => 'application/json' })
    request.body = params.to_json

    response = http.request(request)
    JSON.parse(response.body)
  end
end
