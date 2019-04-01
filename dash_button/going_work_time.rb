require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'date'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
APPLICATION_NAME = 'Google Sheets API Ruby Quickstart'.freeze
CREDENTIALS_PATH = 'credentials.json'.freeze
# The file token.yaml stores the user's access and refresh tokens, and is
# created automatically when the authorization flow completes for the first
# time.
TOKEN_PATH = 'token.yaml'.freeze
SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
def authorize
  client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)                # GDCで作成したJSONファイルを元にクライアントIDを作成
  token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)      # YAMLファイルを元にユーザトークンストレージの実装
  authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(base_url: OOB_URI)
    puts 'Open the following URL in the browser and enter the ' \
         "resulting code after authorization:\n" + url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI
    )
  end
  credentials
end

def main
  # Initialize the API
  service = Google::Apis::SheetsV4::SheetsService.new
  service.client_options.application_name = APPLICATION_NAME
  service.authorization = authorize

  # 出勤管理
  spreadsheet_id = '11Cwzv6GPd4wvwcJs5_vxuZT8lTGpH7B-KGPtxOaviCI' # スプレッドシートID
  range = 'Time_card!A:B'                                         # 入力範囲

  # 出勤時間データ
  going_work_time= {
      values: [[
        Date.today.strftime('%Y/%m/%d'),
        Time.now.strftime('%H:%M:%S')
    ]]
  }

  # スプレッドシート出力
  response = service.append_spreadsheet_value(spreadsheet_id, range, going_work_time, value_input_option: 'USER_ENTERED')
end
