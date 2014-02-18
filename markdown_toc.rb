#!/usr/bin/env ruby

INDENT_SPACES = '    '

def print_usage
  puts <<USAGE
Usage:
  #{$0} <file1> <file2> ... : Output TOC generated from the given files to STDOUT.
Note:
  Command line arguments are expected to be relative paths to markdown files.
  The order of TOC items are preserved.
USAGE
end

class Heading
  def initialize(filepath, line)
    @filepath = filepath
    @level    = line.index ' '
    @text     = line[@level + 1 .. -1].chomp
  end

  def to_toc_item_line
    [
      INDENT_SPACES * (@level - 1),
      '- [',
      @text,
      '](',
      './' + @filepath + '#' + @text.downcase.gsub(' ', '-').gsub(/[^\w_-]/, ''),
      ')'
    ].join('')
  end
end

if ARGV.empty?
  print_usage
else
  paths = ARGV.select { |path| File.file?(path) }
  headings = paths.uniq.flat_map do |path|
    File.readlines(path).grep(/^#+ /).map { |l| Heading.new(path, l) }
  end
  puts headings.map(&:to_toc_item_line).join("\n")
end
