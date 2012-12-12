#!/usr/bin/ruby
$LOAD_PATH << File.dirname(__FILE__)
require 'process_helper'

# - declare variables, defaults (maybe OptionParser style) - (-b/--s3bucketname) (-a --artist)
options = Parser.new do |p|
  p.banner = "Usage:"

  p.option :artist, "Artist", :default => ""
  p.option :title, "Song title pattern - Use \\f for filename, \\a for artist", :default => "\\f"
  p.option :album, "Album title pattern - Use \\d for dirname", :short =>"l", :default => "Rehearsal \\d"
end.process!

# - build up data structure from givens/defaults (filename -> map of tags)
file_opts = ARGV.inject({}) do |all_files, filename|
  all_files[filename] = {
    :title => options[:title].gsub( /\\f/, File.basename(filename) ),
    :artist => options[:artist],
    :album => options[:album].gsub( /\\d/, File.split( File.split(filename)[0] )[1] ),
  }
  all_files
end

pp file_opts

#   - ffmpeg convert each file to tagged mp3
#   - upload tagged mp3 to amazon
#   - create local proxy files .mp3.s3 with URL to s3 destination
# - register new files (git repo)