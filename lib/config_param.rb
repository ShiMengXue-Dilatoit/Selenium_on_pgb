#encoding: utf-8

require 'rubygems'
require 'getoptlong'
require 'yaml'
require 'fileutils'
require 'rest_client'
require 'json'

require_relative '../data/base_env'

module ConfigParam
    include BaseEnv

    # Return true if the argument 'str' was nil or " "
    def is_nil_or_empty(str)
        if str.to_s.strip.length == 0 
            return true 
        end
        return false
    end

    # Helps to get the Jenkins environment variables' value. 
    def get_value_of_env(env, default_value)
        if is_nil_or_empty(env)   
            return default_value
        else 
            return env 
        end
    end

    # Helps to get the global variable value
    # They are used everywhere later.  
    def init
        $browser = ENV['PGBBROWSER'].to_sym
        $lang = ENV['PGBLANG'].to_sym

        puts "+ <lib> ENV[PGBBROWSER] = #{$browser}"
        puts "+ <lib> ENV[PGBLANG] = #{$lang}"

        # liclu:original function 
        # opts = GetoptLong.new(
        #   [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
        #   [ '--port', '-p', GetoptLong::REQUIRED_ARGUMENT ],
        #   [ '--browser', '-b', GetoptLong::REQUIRED_ARGUMENT ],
        #   [ '--lang', '-l', GetoptLong::REQUIRED_ARGUMENT ],
        #   [ '--config', '-c', GetoptLong::REQUIRED_ARGUMENT ],
        #   [ '--test-set', '-t', GetoptLong::REQUIRED_ARGUMENT ],
        #   [ '--skip-sections', '-s', GetoptLong::REQUIRED_ARGUMENT ],
        #   [ '--debug', '-D', GetoptLong::NO_ARGUMENT ]
        # )

        # $config = {}
        # $config['port'] = 4444
        # $config['browser'] = 'firefox'
        # $config['lang'] = 'en_us'
        # $config['test_set'] = nil
        # $config['config'] = {}
        # $config['skip'] = nil
        # $config['debug'] = false

        # Override defaults with values from config file
        #$config.merge!( File.open( "yaml/runtest.yaml" ) { |yf| YAML::load( yf ) } )

        # def usage
        #   puts <<-EOF
          
        # ./runtest [optional arguments]

        # Optional Arguments:

        #   --port/-p		port to reach selenium on; default: #{$config['port']}
        #   --browser/-b		browser; default: #{$config['browser']}
        #   --config/-c		directly overrides values in $yaml_data; format is "foo=bar"; default: #{$config['config']}
        #   --lang/-l     set the languages of browser; default: #{$config['lang']}
        #   --test-set/-t         test set to run; correspondes to a yaml/000*.yaml file generally; default: #{$config['test_set']}
        #   --skip-sections/-s	tests to skip; example: "BasicSearch,Lucky"; see the yaml/000*.yaml files for section lists (same as the file names without ".rb" in tests/); default: #{$config['skip'].to_s}
        #   --debug/-D		debug mode; default #{$config['debug']}

        #   EOF

        #   exit 1
        # end

        # opts.each do |opt, arg|
        #   case opt
        #     when '--help'
        #       usage
        #     when '--debug'
        #       $config['debug'] = true
        #     when '--port'
        #       $config['port'] = arg
        #     when '--browser'
        #       $config['browser'] = arg
        #     when '--test-set'
        #       $config['test_set'] = arg
        #     when '--config'
        #       $config['config'][arg.split(/=/, 2)[0]] = arg.split(/=/, 2)[1]
        #     when '--skip-sections'
        #       $config['skip'] = arg
        #   end
        # end

        # ENV['PORT']=$config['port'].to_s
        # ENV['BROWSER']=$config['browser'].to_s
        # ENV['LANG']=$config['lang'].to_s
        # ENV['SKIP']=$config['skip'].to_s
        # ENV['TEST_SET']=$config['test_set'].to_s
        # ENV['CONFIG']=YAML::dump($config['config'])
        # ENV['DEBUG']=$config['debug'].to_s

        # $browser = $config['browser'].to_sym

        # if $config['debug']
        #   # print "env: "+ENV.inspect+"\n"
        #   exec( "rlwrap", "rspec", "#{$0}/../wrapper.rb" )
        # else
        #   exec( "rspec", "#{$0}/../wrapper.rb" )
        # end
    end 

    def create_folder_unless_exist(folder_name)
        if(File.directory?(folder_name)) 
            puts "+ <lib> folder #{folder_name} --- exists"
        else
            Dir.mkdir(folder_name) 
            puts "+ <lib> folder #{folder_name} --- created"
        end
    end 

    # Initialization work
    # It is to recreate folders, which will be used to store log file and screenshot files. 
    def initialize_params(name_subdir)
        puts "+ <lib> initialize_params begin"

        # Delete the result folder and all subfolders recursively 
        # FileUtils.rm_rf('./auto_results') unless File.directory?('./auto_results')
        # puts "+ ./auto_results/* --- deleted"

        # Then to create the structure
        name_sub_dir = name_subdir
        create_folder_unless_exist("./auto_results")
        create_folder_unless_exist("./auto_results/#{name_sub_dir}")
        create_folder_unless_exist("./auto_results/#{name_sub_dir}/screenshots")
        
        # private_resource = RestClient::Resource.new 'http://loc.build.phonegap.com/api/v1/apps' , {:user => "dil45216+test_free_002@adobetest.com" , :password => "password" , :timeout => 30}
        # response = private_resource.get :accept => :json
        # base_url = "http://loc.build.phonegap.com"
        # json =  JSON.parse(response)
        # json['apps'].each do |i|
        #     url = base_url + i['link']
        #     private_resource = RestClient::Resource.new url , {:user => "dil45216+test_free_002@adobetest.com", :password => "password" , :timeout => 30}
        #     response = private_resource.delete 
        #     puts response.to_str
        # end

        # private_resource_2 = RestClient::Resource.new 'http://loc.build.phonegap.com/api/v1/apps' , {:user => "dil45216+test_free_005@adobetest.com", :password => "password" , :timeout => 30}
        # response_2 = private_resource_2.get :accept => :json
        # json_2 =  JSON.parse(response_2)
        # json_2['apps'].each do |i|
        #     url = base_url + i['link']
        #     private_resource_2 = RestClient::Resource.new url , {:user => "dil45216+test_free_005@adobetest.com" , :password => "password" , :timeout => 30}
        #     response_2 = private_resource_2.delete 
        #     puts response_2.to_str
        # end

        puts "+ <lib> initialize_params end"
    end

    # Path formattor with locale 
    # the result address will be like 
    #   http://loc.build.phonegap.com/people/sign_in?locale=fr_FR
    def path_format_locale(base_url = @base_url, path)
        base_url + path + "?locale=" + $lang.to_s
    end 

end  
