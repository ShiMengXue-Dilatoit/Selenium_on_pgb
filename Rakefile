#encoding: utf-8

require 'rake'
require 'rspec/core/rake_task'
require 'fileutils'

require_relative "./lib/config_param"

# Uses FileList to get an Array of the configuration files
TESTCASE_FILES=FileList['testcases/*.rb']

def init_folders
    browser = ENV['PGBBROWSER']
    lang = ENV['PGBLANG']
    name_subdir = "#{lang}_#{browser}" 

    initialize_params name_subdir

    name_subdir
end

if defined? RSpec
    include ConfigParam

    RSpec::Core::RakeTask.new(:TC, :order) do |t, args| 
        raise "Please specify the testcase number to run, like TC[001], or TC[all] to run all testcases ! " unless args.order

        if "ALL" == args.order.upcase
            name_subdir = init_folders 
            puts "------ Running all testcases ------" 
            t.pattern = "./testcases/*_rspec.rb"
            t.rspec_opts = "--format d >> ./auto_results/#{name_subdir}/all_result.txt "
        elsif TESTCASE_FILES.find { |e| e.include?("#{args.order}") }  
            name_subdir = init_folders  
            puts "TC[#{args.order}] is now running ..."
            t.pattern = "./testcases/TC_#{args.order}*.rb"
            t.rspec_opts = "--format d > ./auto_results/#{name_subdir}/TC_#{args.order}_result.txt "
        else
            raise "Please specify the testcase number to run, like TC[001], or TC[all] to run all testcases ! "
        end
    end

end