require 'dotenv/load'
require 'selenium-webdriver'
require_relative 'tools'

@wait_time = 60
@timeout = 4

# Seleniumの初期化
# class ref: https://www.rubydoc.info/gems/selenium-webdriver/Selenium/WebDriver/Chrome
Selenium::WebDriver.logger.output = File.join("./", "selenium.log")
Selenium::WebDriver.logger.level = :warn
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument '--use-fake-device-for-media-stream'
options.add_argument '--use-fake-ui-for-media-stream'
options.add_preference 'profile.default_content_setting_values.notifications', 1
driver = Selenium::WebDriver.for :chrome, options: options
driver.manage.timeouts.implicit_wait = @timeout
wait = Selenium::WebDriver::Wait.new(timeout: @wait_time)

# Googleのログイン
driver.get('https://accounts.google.com/signin/v2/identifier?hl=ja&passive=true&continue=https%3A%2F%2Fwww.google.co.jp%2F%3Fgws_rd%3Dssl&flowName=GlifWebSignIn&flowEntry=ServiceLogin')

begin
  wait.until{driver.find_element(:id, 'identifierId').displayed?} # メール入力欄が出るまで
  driver.find_element(:id, 'identifierId').send_keys ENV["EMAIL"]
  driver.find_element(:id, 'identifierNext').click
  wait.until {driver.find_element(:name, 'password').displayed?}
  driver.find_element(:name, 'password').send_keys ENV["PASSWORD"]
  driver.find_element(:id, 'passwordNext').click
  wait.until {driver.find_element(:class, 'gLFyf').displayed?} # 検索バーが出るまで
  driver.get "https://meet.google.com/#{ENV["ROOM_KEY"]}"
  wait.until {driver.find_element(:class, 'ZB88ed').displayed?} # カメラオフボタンが出るまで
  driver.find_element(:class, 'ZB88ed').click # マイクオフ
  driver.find_element(:class, 'GOH7Zb').click # ビデオオフ
  driver.find_element(:class, 'Fxmcue').click # 参加
  wait.until {driver.find_element(:class, 'ZaI3hb').displayed?} # UIが出るまで待つ
  driver.find_element(:class, 'ZaI3hb').click # コメント表示
  wait.until {driver.find_element(:class, 'anXpBf').displayed?} # サイドバーが出るまで
  driver.find_elements(:class, 'anXpBf')[1].click # コメント表示タブ
  wait.until {driver.find_element(:class, 'vvTMTb').displayed?} # コメント欄が出るまで
  register_observe driver # observerにスクリプト登録
  sleep 12*60*60
rescue Selenium::WebDriver::Error::NoSuchElementError
  p 'no such element error!!'
  return
end
