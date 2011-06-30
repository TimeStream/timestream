TimeStream
==========

Description
-----------
TimeStream is a minimalist time-tracking solution where you use live status messages to track what you're working on.
It's similar to Twitter or Facebook statuses, but private, secure and with time-tracking functionality.

Learn more at:
[https://timestreamapp.com](https://timestreamapp.com)

Installation
------------
    gem install timestreamapp

Usage and documentation
-----------------------
After installation, login with your TimeStream credentials:

    ts login

To view a list of available commands:

    ts help

Will output:

    Tasks:
      ts commit                 # Commit and push up your Git changes to the remote master with your current TimeStream status as the commit message
      ts current                # Get your current task
      ts date "YYYY-MM-DD"      # Show tasks for a specific date, uses typical formats, e.g.: YYYY-MM-DD, "last monday", MM/DD/YY
      ts help [TASK]            # Describe available tasks or one specific task
      ts login                  # Login to your TimeStream account
      ts logout                 # Logout of your TimeStream account
      ts new "Some new status"  # Add a new task
      ts search "search terms"  # Search tasks
      ts task-time              # Get the task and time together
      ts time                   # Get the duration of your current task
      ts time-task              # Get the time and task together
      ts today                  # Get a list of all of today's tasks

Many of the commands have optional arguments (command line switches). For e.g., to learn more about the "ts current" command, enter the following:

    ts help current

This will output:

    Usage:
      ts current

    Options:
      -f, [--format=FORMAT]  # Specify what you want: time, task, task-time, time-task. If specified, only returns txt.
                             # Default: task
      -o, [--output=OUTPUT]  # Specify an output format: csv, json, pdf, rss, txt or xml
                             # Default: txt
      -i, [--inline]         # Specify if you want the output inline, i.e. with NO newline after the output. Useful when scripting.

Examples
--------

Show the duration of your current task:

    ts time

Show your current time and task together:

    ts time-task

Will output:

    [04:34:22] This is my awesome task

Add a new task:

    ts new "This is some other awesome task"

Show all of today's tasks:

    ts today

Will output something like:

    00:02:00  This is my awesome task
    00:15:54  This is some other awesome task

Search for entries:

    ts search "some search terms"

Show your current task in JSON format:

    ts current -o=json

Show entries for a specific date:

    ts date "2011-05-11"

Automatically add changed files, commit them with your current TimeStream status as the commit message and push it up to the remote master with Git:

    ts commit
