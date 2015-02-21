#!/usr/bin/env ruby

require_relative './markdown_toc.rb'

START_MARKER_DEFAULT = '**Table of contents**'
END_MARKER_DEFAULT   = '---'

def print_usage
  puts <<USAGE
Usage:
  #{$0} --dest-file=<dest-file> --start-marker=<start-marker> --end-marker=<end-marker> <file1> <file2> ...
    Generate TOC from <file1>, <file2>, ..., then insert the TOC to <dest-file>.
    Position to insert the TOC must be given by <start-marker> and <end-marker>.
    The markers are searched in <dest-file> by exact line matching.
    <start-marker> deaults to '#{START_MARKER_DEFAULT}' and <end-marker> defaults to '#{END_MARKER_DEFAULT}'.
Note:
  Markdown file paths are expected to be relative to the current directory.
  The items in the generated TOC are ordered aoccording to the order of input files.
USAGE
end

class InsertTocCommand
  def initialize(argv)
    @argv = argv.dup
    @dest_file    = getopt('dest-file'   ) or raise 'dest-file parameter not given!'
    @start_marker = getopt('start-marker') || START_MARKER_DEFAULT
    @end_marker   = getopt('end-marker'  ) || END_MARKER_DEFAULT
    @files        = @argv.select { |path| File.file?(path) }
    raise 'dest-file not found!'   if !File.exist?(@dest_file)
    raise 'No target files found!' if @files.empty?
  end

  def getopt(name)
    start = "--#{name}="
    value = @argv.find { |arg| arg.start_with? start } or return
    @argv.delete value
    value[start.size .. -1]
  end

  def insert
    File.write(@dest_file, gen_new_file_content)
  end

  def gen_new_file_content
    lines = File.readlines(@dest_file).map(&:chomp)
    i = lines.index(@start_marker) or raise 'start-marker not found in dest-file!'
    j = lines[i .. -1].index(@end_marker) or raise 'end-marker not found in dest-file!'
    updated_lines = lines[0 .. i] + [''] + gen_toc_lines(@files) + [''] + lines[i+j .. -1] + ['']
    updated_lines.join("\n")
  end
end

if ARGV.size <= 1
  print_usage
else
  InsertTocCommand.new(ARGV).insert
end
