#encoding: utf-8

require 'rubygems'
require 'rspec'
require 'selenium-webdriver'
require 'yaml'

require_relative "../tools/register_dialog"
require_relative "../tools/sign_in_github_dialog"
require_relative "../action/register_page"
require_relative "../data/base_env"
require_relative "../lib/config_param"
require_relative "../lib/webdriver_helper"

describe "TC_003: Register -> create an Adobe ID with provided email" do 
    include RegisterDialog
    include SignInGithubDialog
    include BaseEnv
    include ConfigParam
    include WebdriverHelper

    before(:all) do 
        init
        @order_of_it = WebdriverHelper::Counter.new
        @name_screenshot = "TC_003_IT_"
        @driver = browser
        @time = Time.now
        @str_name = @time.year.to_s + @time.month.to_s + @time.day.to_s + @time.hour.to_s + @time.min.to_s
        @driver.manage.window.maximize
        @register_page = RegisterPage.new @driver
        @base_url = base_url
        @data_xpath = YAML::load(File.read(File.expand_path("../../data/data_xpath.yml",__FILE__)))
        @data_url = YAML::load(File.read(File.expand_path("../../data/data_url.yml",__FILE__)))
        @data_user = YAML::load(File.read(File.expand_path("../../data/data_user.yml",__FILE__)))
        @data_str = YAML::load(File.read(File.expand_path("../../data/data_str.yml",__FILE__)))

        @user_info = {
            email_address:  "pgbtesttiing_" + @time.year.to_s + @time.month.to_s + @time.day.to_s + "@g990mail.com",
            password:        "pgbtesting001",
            retype_pass:    "pgbtesting001",
            first_name:        "pgb",
            last_name:        "testing",
            country_region:    "JP"
        }    

        @driver.get path_format_locale("/plans/free-adobeid") 
        sleep 5
        @driver.switch_to.frame(0)
        sleep 5
        create_an_adobe_id_btn.click
        sleep 5
    end

    after(:each) do  # Take screenshot in case of failure
        @name_screenshot += @order_of_it.inc.to_s
        begin
            if example.exception != nil
                take_screenshot_with_name @name_screenshot
            end
        ensure
            @driver.quit
        end
    end

    it "IT_001: Got an error message with invalid Adobe ID (Email Address)" do
        user = @user_info.clone
        user[:email_address] = @data_user[$lang][:invalid_user][:id]
        
        sleep 15
        @warnings = @register_page.enter_register_information(user)
        @warnings.should eql @data_str[$lang][:PGB_enter_a_valid_email]
    end

    it "IT_002: Got an error message with unmatched password" do 
        user = @user_info.clone
        user[:retype_pass] = "something_not_the_original_password"
        
        @warnings = @register_page.enter_register_information(user)
        sleep 5
        @warnings.should eql @data_str[$lang][:PGB_retyped_password_unmatched]
    end

    it "IT_003: Got an error message with invalid First Name" do 
        user = @user_info.clone
        user[:first_name] = "ſЊџЛ^&*!@##@яѨ҉ҝҾ"
        
        @warnings = @register_page.enter_register_information(user)
        sleep 5
        @warnings.should eql @data_str[$lang][:PGB_first_name_invalid]
    end

    it "IT_004: Got an error message with invalid Last Name" do 
        user = @user_info.clone
        user[:last_name] = "ſЊџЛ^&*!@##@яѨ҉ҝҾ"
        
        @warnings = @register_page.enter_register_information(user)
        sleep 5
        @warnings.should eql @data_str[$lang][:PGB_last_name_invalid]
    end

    it "IT_005: Got an error message without a country selected" do
      user = @user_info.clone
        user[:country_region] =""
        
        @warnings = @register_page.enter_register_information(user)
        sleep 5
        @warnings.should eql @data_str[$lang][:PGB_without_selecting_country]
    end

    it "IT_006: page direct to '/apps' page after successfully new Adobe ID was created with valid appropriate email and password" do 
        @user = @user_info.clone
        
        @user[:email_address] ="dil45216+test_" + @str_name + "@adobetest.com"
        @user[:password] = "password"
        @user[:retype_pass] = "password"

        
        sleep 10
        @register_page.enter_register_information(@user)
        sleep 5
        @register_page.have_read_and_agree
        wait_for_page_load(@base_url + @data_url[:sign_in_successfully])
        @driver.current_url.should eql @base_url + @data_url[:sign_in_successfully]
    end

end