require 'base64'

# 引数をエンコード対象に格納
data = ARGV[0]
encoding_data = Base64.encode64(data)
puts encoding_data