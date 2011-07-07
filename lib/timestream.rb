require "timestream/version"
require 'rubygems'
require 'thor'
require 'json'
require 'httparty'
require 'timestream/version'

module Timestream

  class CLI < Thor

    include Thor::Actions
    include Thor::Shell

    map "-C" => :current
    map "-c" => :current
    map "current" => :current
    map "task" => :current
    map "status" => :current

    map "time-task" => :time_task
    map "task-task" => :task_time

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

    map "-v" => :version
    map "-V" => :version
    map "--version" => :version

    map "-w" => :web
    map "-W" => :web

    map "intro" => :info

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

      def check_credentials
        file_path = File.expand_path("~/.tsconfig")
        if File.exists?(file_path)
          return true
        else
          say("Please log in first.", :red)
          login
        end
      end

      def ask_password(statement, color=nil)
        say("#{statement} ", color)
        # Hide standard input
        system "stty -echo"
        password = $stdin.gets.strip
        # Restore standard input
        system "stty echo"
        system "echo "
        return password
      end

    end

    desc "login", "Login to your TimeStream account"
    def login
      # Ask for credentials
      username = ask "Username:"
      # password = ask "Password:"
      password = ask_password "Password:"

      # Hit the login API and capture the response
      response = HTTParty.post("https://timestreamapp.com/login.txt", :query => {:username => username, :password => password})

      if response.body == 'Success: Valid credentials'
        creds = {:username => username, :password => password}
        # create_file "~/.tsconfig", JSON.pretty_generate(creds), :force => true
        create_file "~/.tsconfig", JSON.pretty_generate(creds), {:force => true, :verbose => false}
        say("Storing creds under ~/.tsconfig")
        say(response.body, :green)
      else
        say("Invalid credentials, please try again.", :red)
        login
      end
    end

    desc "logout", "Logout of your TimeStream account"
    def logout
      remove_file "~/.tsconfig", {:verbose => false}
      say("You are now logged out.", :red)
    end

    desc "new \"Some new status\"", "Add a new task"
    def new(task)

      check_credentials

      if task == nil
        say("Task can not be empty. Please supply a status to post.", :red)
      else
        response = HTTParty.post("https://timestreamapp.com/#{get_username}.txt", :query => {:password => get_password, :source => 'timestream_gem', :task => task})

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
      check_credentials

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

    desc "time", "Get the duration of your current task"
    method_option :inline, :type => :boolean, :aliases => '-i', :default => false, :desc => 'Specify if you want the output inline, i.e. with NO newline after the output. Useful when scripting.'
    def time
      check_credentials

      inline = options[:inline]

      response = HTTParty.get("https://timestreamapp.com/#{get_username}/current/time.txt", :query => {:password => get_password})

      if inline == true
        say(response.body, nil, false)
      else
        say(response.body, nil)
      end
    end

    desc "time-task", "Get the time and task together"
    method_option :inline, :type => :boolean, :aliases => '-i', :default => false, :desc => 'Specify if you want the output inline, i.e. with NO newline after the output. Useful when scripting.'
    def time_task
      check_credentials

      inline = options[:inline]

      response = HTTParty.get("https://timestreamapp.com/#{get_username}/current/time-task.txt", :query => {:password => get_password})

      if inline == true
        say(response.body, nil, false)
      else
        say(response.body, nil)
      end
    end

    desc "task-time", "Get the task and time together"
    method_option :inline, :type => :boolean, :aliases => '-i', :default => false, :desc => 'Specify if you want the output inline, i.e. with NO newline after the output. Useful when scripting.'
    def task_time
      check_credentials

      inline = options[:inline]

      response = HTTParty.get("https://timestreamapp.com/#{get_username}/current/task-time.txt", :query => {:password => get_password})

      if inline == true
        say(response.body, nil, false)
      else
        say(response.body, nil)
      end
    end

    desc "today", "Get a list of all of today's tasks"
    method_option :output, :type => :string, :aliases => '-o', :default => 'txt', :desc => 'Specify an output format: csv, json, pdf, rss, txt or xml'
    def today
      check_credentials

      output_format = options[:output]
      response = HTTParty.get("https://timestreamapp.com/#{get_username}.#{output_format}", :query => {:password => get_password})
      say(response.body, nil)
    end

    desc "search \"search terms\"", "Search tasks"
    method_option :output, :type => :string, :aliases => '-o', :default => 'txt', :desc => 'Specify an output format: csv, json, pdf, rss, txt or xml'
    def search(search_terms)
      check_credentials

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
      check_credentials

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
      check_credentials

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
        # system("git push #{origin} #{master}")
        system("git push")
      end
    end

    desc "web", "Open TimeStream in your web browser"
    def web
      system("open https://timestreamapp.com/#{get_username}")
    end

    desc "version", "Show the version of the TimeStream gem"
    def version
      say(Timestream::VERSION)
      # VERSION
    end

    desc "info", "Learn about TimeStream"
    def info
      say("Welcome to TimeStream! TimeStream is a minimalist, web-based time-tracking system.")
      say("You can learn more at: https://timestreamapp.com")

      if yes?("Would you like to go TimeStreamApp.com now?", :green)
        system("open https://timestreamapp.com")
      end
    end

  end

end
