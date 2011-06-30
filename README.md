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

Many of the commands have optional arguments command line switches. For e.g., to learn more about the "ts current" command, enter the following:

    ts help current
