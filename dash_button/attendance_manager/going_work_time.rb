require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'date'

APPLICATION_NAME = 'Google Sheets API Ruby Quickstart'.freeze
CLIENT_SECRET_PATH = 'client_secret.json'.freeze
# TOKEN_PATH = 'token.yaml'.freeze
SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS

def authorize
  authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(CLIENT_SECRET_PATH),
      scope: Google::Apis::SheetsV4::AUTH_SPREADSHEETS)
  authorizer.fetch_access_token!
  authorizer
end

def main event:, context:
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
