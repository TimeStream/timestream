require "timestream/version"
require 'rubygems'
require 'thor'
require 'json'
require 'httparty'

module Timestream

  class CLI < Thor

    include Thor::Actions
    include Thor::Shell

    map "-C" => :current
    map "-c" => :current
    map "current" => :current

    map "-L" => :login
    map "-l" => :login
    map "login" => :login

    map "-N" => :new
    map "-n" => :new
    map "new" => :new

    map "-T" => :today
    map "-t" => :today
    map "today" => :today

    map "-S" => :search
    map "-s" => :search
    map "search" => :search

    map "-D" => :date
    map "-d" => :date
    map "date" => :date

    map "-CM" => :commit
    map "-cm" => :commit
    map "commit" => :commit

    # Define some private functions
    no_tasks do
      # Used to check the credentials

      def get_username
        file_path = File.expand_path("~/.tsconfig")
        parsed_config = JSON.parse(File.read(file_path))
        return parsed_config['username']
      end

      def get_password
        file_path = File.expand_path("~/.tsconfig")
        parsed_config = JSON.parse(File.read(file_path))
        return parsed_config['password']
      end
    end

    desc "login", "Login to your TimeStream account"
    def login
      # Ask for credentials
      username = ask "Username:"
      password = ask "Password:"

      # Hit the login API and capture the response
      response = HTTParty.post("https://timestreamapp.com/login.txt", :query => {:username => username, :password => password})

      if response.body == 'Success: Valid credentials'
        creds = {:username => username, :password => password}
        create_file "~/.tsconfig", JSON.pretty_generate(creds), :force => true
        say(response.body, :green)
      else
        say("Invalid credentials, please try again.", :red)
        login
      end

    end

    desc "new \"Some new status\"", "Add a new task"
    def new(task)

      if task == nil
        say("Task can not be empty. Please supply a status to post.", :red)
      else
        response = HTTParty.post("https://timestreamapp.com/#{get_username}.txt", :query => {:password => get_password, :source => 'bash', :task => task})

        if response.body == 'Success: New task successfully added.'
          say(response.body, :green)
        else
          say(response.body, :red)
        end
      end

    end

    desc "current", "Get your current task"
    method_option :output, :type => :string, :aliases => '-o', :default => 'txt', :desc => 'Specify an output format: csv, json, pdf, rss, txt or xml'
    method_option :format, :type => :string, :aliases => '-f', :default => 'task', :desc => 'Specify what you want: time, task, task-time, time-task. If specified, only returns txt.'
    method_option :inline, :type => :boolean, :aliases => '-i', :default => false, :desc => 'Specify if you want the output inline, i.e. with NO newline after the output. Useful when scripting.'
    def current
      output_format = options[:output]
      view_format = options[:format]
      inline = options[:inline]

      case view_format
        when 'time'
          response = HTTParty.get("https://timestreamapp.com/#{get_username}/current/time.txt", :query => {:password => get_password})
        when 'task-time'
          response = HTTParty.get("https://timestreamapp.com/#{get_username}/current/task-time.txt", :query => {:password => get_password})
        when 'time-task'
          response = HTTParty.get("https://timestreamapp.com/#{get_username}/current/time-task.txt", :query => {:password => get_password})
        else
          response = HTTParty.get("https://timestreamapp.com/#{get_username}/current.#{output_format}", :query => {:password => get_password})
      end

      if inline == true
        say(response.body, nil, false)
      else
        say(response.body, nil)
      end
    end

    desc "today", "Get a list of all of today's tasks"
    method_option :output, :type => :string, :aliases => '-o', :default => 'txt', :desc => 'Specify an output format: csv, json, pdf, rss, txt or xml'
    def today
      output_format = options[:output]
      response = HTTParty.get("https://timestreamapp.com/#{get_username}.#{output_format}", :query => {:password => get_password})
      say(response.body, nil)
    end

    desc "search \"search terms\"", "Search tasks"
    method_option :output, :type => :string, :aliases => '-o', :default => 'txt', :desc => 'Specify an output format: csv, json, pdf, rss, txt or xml'
    def search(search_terms)
      original_search_terms = search_terms
      search_terms = search_terms.split
      search_terms = search_terms.join("+")

      output_format = options[:output]
      response = HTTParty.get("https://timestreamapp.com/#{get_username}/search/#{search_terms}.#{output_format}", :query => {:password => get_password})

      if response.body ==""
        say("Sorry, no search results found for: #{original_search_terms}", :red)
      else
        say(response.body, nil)
      end
    end

    desc "date \"YYYY-MM-DD\"", "Show tasks for a specific date, uses typical formats, e.g.: YYYY-MM-DD, \"last monday\", MM/DD/YY"
    method_option :output, :type => :string, :aliases => '-o', :default => 'txt', :desc => 'Specify an output format: csv, json, pdf, rss, txt or xml'
    def date(requested_date)

      original_requested_date = requested_date
      requested_date = Date.parse(requested_date)
      requested_date = requested_date.strftime("%F")

      output_format = options[:output]
      response = HTTParty.get("https://timestreamapp.com/#{get_username}/#{requested_date}.#{output_format}", :query => {:password => get_password})

      if response.body ==""
        say("Sorry, no entries found for: #{original_requested_date}", :red)
      else
        say(response.body, nil)
      end
    end

    desc "commit", "Commit and push up your Git changes to the remote master with your current TimeStream status as the commit message"
    method_option :format, :type => :string, :aliases => '-f', :default => 'task', :desc => 'Specify the format of your commit message: time, task, task-time, time-task.'
    method_option :push, :type => :boolean, :aliases => '-p', :default => true, :desc => 'Make false if you don\'t want to push up your changes, just add and commit.'
    method_option :origin, :type => :string, :aliases => '-o', :default => 'origin', :desc => 'Specify the origin'
    method_option :master, :type => :string, :aliases => '-m', :default => 'master', :desc => 'Specify the master'
    def commit
      view_format = options[:format]
      push = options[:push]
      origin = options[:origin]
      master = options[:master]

      case view_format
        when 'time'
          response = HTTParty.get("https://timestreamapp.com/#{get_username}/current/time.txt", :query => {:password => get_password})
        when 'task-time'
          response = HTTParty.get("https://timestreamapp.com/#{get_username}/current/task-time.txt", :query => {:password => get_password})
        when 'time-task'
          response = HTTParty.get("https://timestreamapp.com/#{get_username}/current/time-task.txt", :query => {:password => get_password})
        else
          response = HTTParty.get("https://timestreamapp.com/#{get_username}/current.txt", :query => {:password => get_password})
      end

      commit_message = response.body

      system("git add .")
      system("git commit -m \"#{commit_message}\"")

      if push == true
        system("git push #{origin} #{master}")
      end
    end

  end

end
