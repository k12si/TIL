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

# def main event:, context:
def main event:, context:
  # Initialize the API
  service = Google::Apis::SheetsV4::SheetsService.new
  service.client_options.application_name = APPLICATION_NAME
  service.authorization = authorize

  # Metadata
  spreadsheet_id = '11Cwzv6GPd4wvwcJs5_vxuZT8lTGpH7B-KGPtxOaviCI' # スプレッドシートID
  range = 'Time_card!A:C'                                         # 取得範囲

  # 退勤入力前の準備(レコードを取得)
  records = service.get_spreadsheet_values(spreadsheet_id, range).to_h[:values]
  record_num = records.length

  # 入力範囲
  update_range = "Time_card!A#{record_num}:C#{record_num}"

  # 退勤時間データ作成
  update_record = records[-1]
  clock_out_time= {
      values: [ update_record.push(Time.now.strftime('%H:%M:%S')) ]
  }

  # スプレッドシート出力
  response = service.update_spreadsheet_value(spreadsheet_id, update_range, clock_out_time, value_input_option: 'USER_ENTERED')
end
