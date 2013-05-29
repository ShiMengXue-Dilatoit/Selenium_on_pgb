#encoding: utf-8

require 'yaml'
require_relative "../tools/app_builds_dialog"
require_relative "../data/base_env"
require_relative "../lib/config_param"
require_relative "../lib/webdriver_helper"

class AppBuildsPage
    include AppBuildsDialog
    include NewAppDialog
    include BaseEnv
    include WebdriverHelper

    def initialize(driver, options = {})
        os = win_or_mac
        @driver = driver
        @base_url = base_url
        @data_xpath = options.fetch(:xpath)
        @data_str = options.fetch(:str)
        @data_user = options.fetch(:user)
        @data_url = options.fetch(:url)
        @data_signing_key = YAML::load(File.read(File.expand_path("../../data/data_signing_key.yml",__FILE__)))
    end
    
# --- iOS
    def ios_add_signing_key
        ios_signing_key_title_input.send_keys "abc" + @data_signing_key[:ios][:name_valid]
        if os == "win" 
            ios_signing_key_choose_cert_btn.send_keys("C:\\signing_key\\ios\\LichuanIQEKey.p12")
            ios_signing_key_choose_prov_btn.send_keys("C:\\signing_key\\ios\\Lichuanlu.mobileprovision")
        else
            ios_signing_key_choose_cert_btn.send_keys File.expand_path(@data_signing_key[:ios][:valid][:cert],__FILE__)
            ios_signing_key_choose_prov_btn.send_keys File.expand_path(@data_signing_key[:ios][:valid][:profile],__FILE__)
        end
        ios_signing_key_submit_btn.click
    end

    def ios_get_status_of_the_signing_key
        return ios_signing_key_status.text
    end

    def ios_get_error_msg_of_the_signing_key
        Selenium::WebDriver::Wait.new(:timeout => 120).until { ios_signing_key_error_btn }
        ios_signing_key_error_btn.click
        txt = ios_signing_key_error_msg.text
        return txt
    end

    def to_unlock_ios_signing_key
        Selenium::WebDriver::Wait.new(:timeout => 120).until { ios_signing_key_status }
        ios_signing_key_status.click
        ios_signing_key_unlock_password_input.send_keys @data_signing_key[:android][:key_password]
        ios_signing_key_unlock_submit_btn.click
    end

    def ios_get_signing_key_name_of_id(id)
        puts "+ <action><app_builds_page> iOS: Trying to get name of signing-key{id: #{id}} "
        puts "+ @base_url = #{@base_url}"
        private_resource = RestClient::Resource.new(
            "#{@base_url}/api/v1/apps/#{id}", 
            :user => @data_user[$lang][:adobe_id_free_002][:id] , 
            :password => @data_user[$lang][:adobe_id_free_002][:password], 
            :timeout => 60)
        response = private_resource.get :accept => :json
        json =  JSON.parse(response)

        keys = json['keys']['ios']
        if keys == nil 
            return "" 
        else
            return keys['title']
        end
        
    end
# --- /iOS

# --- Android
    def android_add_signing_key
        android_signing_key_title_input.send_keys "abc" + @data_signing_key[:android][:name_valid]
        android_signing_key_alias.send_keys @data_signing_key[:android][:name_valid]
        if os == "win" 
            android_signing_key_choose_keystore_btn.send_keys("C:\\signing_key\\android\\android-dilato.keystore")
        else
            android_signing_key_choose_keystore_btn.send_keys File.expand_path(@data_signing_key[:android][:valid][:keystore],__FILE__)
        end
        android_signing_key_submit_btn.click
    end

    def android_get_status_of_the_signing_key
        return android_signing_key_status.text
    end

    def android_get_error_msg_of_the_signing_key
        Selenium::WebDriver::Wait.new(:timeout => 120).until { android_signing_key_error_btn }
        android_signing_key_error_btn.click
        txt = android_signing_key_error_msg.text
        return txt
    end

    def to_unlock_android_signing_key
        Selenium::WebDriver::Wait.new(:timeout => 120).until { android_signing_key_status }
        android_signing_key_status.click
        android_signing_key_unlock_password_input.send_keys @data_signing_key[:android][:key_password]
        android_signing_key_unlock_submit_btn.click
    end

    def android_get_signing_key_name_of(id)
        puts "+ <action><app_builds_page> Android: Trying to get name of signing-key{id: #{id}} "
        puts "+ @base_url = #{@base_url}"
        sleep 10
        private_resource = RestClient::Resource.new(
            "#{@base_url}/api/v1/apps/#{id}", 
            :user => @data_user[$lang][:adobe_id_free_002][:id] , 
            :password => @data_user[$lang][:adobe_id_free_002][:password] , 
            :timeout => 60)
        response = private_resource.get :accept => :json
        json =  JSON.parse(response)
        keys = json['keys']['android']
        if keys == nil 
            return ""
        else
            return keys['title']
        end
    end
# --- /Android

# --- BlackBerry
    def blackberry_add_signing_key
        blackberry_signing_key_title_input.send_keys "abc" + @data_signing_key[:blackberry][:name_valid]
        if os == "win" 
            blackberry_signing_key_choose_csk_btn.send_keys("C:\\signing_key\\blackberry\\barsigner.csk")
            blackberry_signing_key_choose_db_btn.send_keys("C:\\signing_key\\blackberry\\barsigner.db")
        else
            blackberry_signing_key_choose_csk_btn.send_keys File.expand_path(@data_signing_key[:blackberry][:valid][:csk],__FILE__)
            blackberry_signing_key_choose_db_btn.send_keys File.expand_path(@data_signing_key[:blackberry][:valid][:db],__FILE__)
        end
        blackberry_signing_key_submit_btn.click
    end

    def blackberry_get_status_of_the_signing_key
        return blackberry_signing_key_status.text
    end

    def blackberry_get_error_msg_of_the_signing_key
        Selenium::WebDriver::Wait.new(:timeout => 120).until { blackberry_signing_key_error_btn }
        blackberry_signing_key_error_btn.click
        txt = blackberry_signing_key_error_msg.text
        puts "+ <action><app_builds_page> the blackberry error message: #{txt}"
        return txt
    end

    def to_unlock_blackberry_signing_key
        Selenium::WebDriver::Wait.new(:timeout => 120).until { blackberry_signing_key_status }
        blackberry_signing_key_status.click
        blackberry_signing_key_unlock_password_input.send_keys @data_signing_key[:blackberry][:key_password]
        balckberry_signing_key_unlock_submit_btn.click
    end

    def blackberry_get_signing_key_name_of id 
        puts "+ <action><app_builds_page> BlackBerry: Trying to get name of signing-key{id: #{id}} "
        puts "+ @base_url = #{@base_url}"
        sleep 10
        private_resource = RestClient::Resource.new(
            "#{@base_url}/api/v1/apps/#{id}", 
            :user => @data_user[$lang][:adobe_id_free_002][:id] , 
            :password => @data_user[$lang][:adobe_id_free_002][:password] , 
            :timeout => 60)
        response = private_resource.get :accept => :json
        json =  JSON.parse(response)
        keys = json['keys']['blackberry']
        if keys == nil 
            return ""
        else
            return keys['title']
        end
    end
# --- /BlackBerry

end