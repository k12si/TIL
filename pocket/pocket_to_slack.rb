require 'json'
require 'net/https'
require 'slack'
require 'date'
require 'dotenv'

# .envファイルの読み込み
Dotenv.load

CONSUMER_KEY=ENV['POCKET_CONSUMER_KEY']
POCKET_ACCESS_TOKEN=ENV['POCKET_ACCESS_TOKEN']

Slack.configure do |config|
  config.token =ENV['SLACK_API_TOKEN']
end

def request(host, path, params = {}, headers = {})
  data = params.map { |k, v| [k, v.to_s.encode('utf-8')] }.to_h

  http = Net::HTTP.new(host, 443)
  http.use_ssl = true

  req = Net::HTTP::Post.new(path, initheader = headers)
  req.set_form_data(data)

  res = http.request(req)
end

headers = {
    'Content-Type' =>'application/json; charset=UTF-8',
    'X-Accept' => 'application/json'
}

# 昨日pocketに追加した記事を抽出
article_get_time = Date.today.to_time.to_i

params = {:consumer_key => CONSUMER_KEY, :access_token => POCKET_ACCESS_TOKEN, :since => article_get_time, :tag => '4-dimensional-pocket'}
res = request('getpocket.com', '/v3/get', params, headers)

raise "error: cannot get response." unless res.is_a?(Net::HTTPOK)

res_json = JSON.parse(res.body)

unless res_json.has_key?('list')
  exit
end

res_json['list'].each do |id, article|
  # post to slack
  attachments = [
      {
          color: '#4169e1',
          fields:[
            title: article['resolved_title'],
            value: article['given_url']
          ]
    }
  ]
  Slack.chat_postMessage(channel: '4-dimensional-pocket', attachments: attachments)
end
