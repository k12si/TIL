目的
===
Pocketの記事をSlackにリマインド送信

実行
===
``bundle exec ruby pocket_to_slack.rb``

利用したもの
===
* ruby 2.5.0
* Heroku
* Pocket: Developer API
* Slack API

実装の流れ
===
### Pocket
* [アプリケーションの登録](https://getpocket.com/developer/apps/)
* コンシューマキー取得
* OAuth認証
* アクセストークン取得

### Slack
* [アプリケーションの登録](https://api.slack.com/apps)
* アプリが利用できるSlackAPIの**Permission Scope**の設定
* アプリを連携させたいSlackチームにインストール
* アクセストークン取得

### rubyスクリプト
* <https://getpocket.com/v3/get>へPOSTでPocket記事取得
* `Slack.chat_postMessage`を利用し、`attachment`表記でSlackに送信

### Heroku
* [heroku-cliをインストール](https://devcenter.heroku.com/articles/heroku-cli)
* `heroku login`
* rubyの実行環境を構築
    * `heroku create --buildpack https://github.com/heroku/heroku-buildpack-ruby.git`
* Gemfile作成
    * `bundle install --path vendor/bundle`
* デプロイ
    * `git push heroku master`
* 環境変数設定
    * `heroku config:set POCKET_CONSUMER_KEY="xxx" POCKET_ACCESS_TOKEN="xxx" SLACK_API_TOKEN="xxx"`
* スケジュール実行
    * アドオンの追加
        * `heroku addons:create scheduler:standard`
    * GUIでスケジューリングの設定
        * `heroku addons:open scheduler`
        * `bundle exec ruby pocket-to-slack`を実行対象に追加
        * Herokuのスケジューリングの時刻設定はUTCなので注意



