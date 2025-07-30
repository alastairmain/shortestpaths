
"""
Helper function to log events.

"""

using Dates

function log_event(msg::String; logfile="..ShortestPaths/logs/log.txt")
  # open and append to log-file the event
  logfile_path = joinpath(@__DIR__, "..", "logs", "log.txt")
  open(logfile_path, "a") do io
    timestamp = Dates.format(now(), "yyyy-mm-dd HH:MM:SS")
    println(io, "[$timestamp] $msg")
  end
end