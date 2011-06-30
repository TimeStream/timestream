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

Will output something like:

    04:41:45

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

    ts search "awesome"

Will output:

    00:00:49  This is my awesome task  2011-06-07 10:10:46  2011-06-07 10:11:35
    00:04:09  This is some other awesome task 2011-04-07 17:03:42  2011-04-07 17:07:51

Show your current task in JSON format:

    ts current -o=json

Will output:

    {
      "task":"This is my awesome task",
      "duration":"04:44:35",
      "seconds":"17075",
      "created_at":"2011-06-30 11:53:26",
      "timezone":"America/Los_Angeles",
      "source":"quicksilver",
      "ip":"67.188.42.153"
    }

Show entries for a specific date:

    ts date "2011-05-11"

Will output something like:

    01:19:03  SOMECLIENT > Phone > Meeting about 3.x items
    00:11:05  ROCKERISTA > CM > Creating header image for Concert Post
    00:00:36  VGTRACKER > Dev > Defining responders > PDF > Trying to get webfonts to work
    00:00:24  VGTRACKER > Dev > Making root point to home
    00:30:50  VGTRACKER > IT > Install production SSL certs
    00:17:40  VGTRACKER > IT > Rerouting all traffic through https

Automatically add changed files, commit them with your current TimeStream status as the commit message and push it up to the remote master with Git:

    ts commit
