#!/usr/bin/env ruby

require 'cgi'

INDENT_SPACES = '    '

def print_usage
  puts <<USAGE
Usage:
  #{$0} <file1> <file2> ... : Output TOC generated from the given files to STDOUT.
Note:
  Command line arguments are expected to be relative paths to markdown files.
  The order of TOC items is preserved.
USAGE
end

class Heading
  def initialize(filepath, line)
    @filepath = filepath
    @level    = line.index ' '
    @text     = line[@level + 1 .. -1].chomp
  end

  def to_toc_item_line
    section_name = CGI.escape(@text.downcase.gsub(' ', '-').gsub(/[!-,:-@\[-\^{-~.\/`]/, ''))
    [
      INDENT_SPACES * (@level - 1),
      '- [',
      @text,
      '](',
      './' + @filepath + '#' + section_name,
      ')'
    ].join('')
  end
end

def gen_toc_lines(paths)
  headings = paths.uniq.flat_map do |path|
    File.readlines(path).grep(/^#+ /).map { |l| Heading.new(path, l) }
  end
  headings.map(&:to_toc_item_line)
end

if __FILE__ == $0
  if ARGV.empty?
    print_usage
  else
    puts gen_toc_lines(ARGV.select { |path| File.file?(path) }).join("\n")
  end
end
