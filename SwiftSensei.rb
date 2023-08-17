#!/usr/bin/ruby
# encoding: utf-8

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

THRESHOLD = 5

# Check if 'colorize' gem is installed
unless `gem list`.include?('colorize')
  puts "Please install the 'colorize' gem using 'gem install colorize'.".red
  exit
end

require 'colorize'

class CommentAnalyzer
  attr_reader :todos, :fixmes

  def initialize
    @todos = []
    @fixmes = []
  end
  
  def locate
    all_files = Dir.glob("**/*.swift").reject { |path| File.directory?(path) }
    all_files.each do |file|
      File.readlines(file).each_with_index do |line, index|
        @todos << {file: file, line: index + 1, comment: line.strip} if line.include?('TODO')
        @fixmes << {file: file, line: index + 1, comment: line.strip} if line.include?('FIXME')
      end
    end
  end
  
  def display
    puts "\nTODO Comments:".yellow
    @todos.each do |todo|
      puts "#{todo[:file]}:#{todo[:line]} - #{todo[:comment]}"
    end

    puts "\nFIXME Comments:".red
    @fixmes.each do |fixme|
      puts "#{fixme[:file]}:#{fixme[:line]} - #{fixme[:comment]}"
    end
  end
end

class CodeQualityAnalyzer
    attr_reader :duplicate_lines, :non_camel_case_vars, :unused_vars, :deep_nesting, :large_files, :magic_numbers, :inconsistent_indentation, :force_unwraps
    
    def initialize
        @duplicate_lines = []
        @non_camel_case_vars = []
        @unused_vars = []
        @deep_nesting = []
        @large_files = []
        @magic_numbers = []
        @inconsistent_indentation = []
        @force_unwraps = []
    end
    
    def analyze
        all_files = Dir.glob("**/*.swift").reject { |path| File.directory?(path) }
        all_files.each do |file|
            lines = File.readlines(file)
            check_duplicate_lines(file, lines)
            check_variable_naming(file, lines)
            check_unused_variables(file, lines)
            check_deep_nesting(file, lines)
            check_large_files(file, lines)
            check_magic_numbers(file, lines)
            check_indentation(file, lines)
            check_force_unwraps(file, lines)
        end
    end
    
    def check_variable_naming(file, lines)
      lines.each_with_index do |line, index|
        # Check for non-camelCase variable declarations
        if line.match?(/var [a-z]+_[a-z]+|let [a-z]+_[a-z]+/)
          @non_camel_case_vars << {file: file, line: index + 1, content: line.strip}
        end
      end
    end
    
    private
    
    def check_duplicate_lines(file, lines)
      lines.each_with_index do |line, index|
        next_line_index = index + 1

        # Skip lines that are too short or are common boilerplate
        next if line.strip.length < 5 || common_boilerplate?(line.strip, lines)

        while next_line_index < lines.length
          if line.strip == lines[next_line_index].strip && !line.strip.empty? && !likely_apple_api?(line.strip, lines, index)
            @duplicate_lines << {file: file, line: index + 1, duplicate_line: next_line_index + 1, content: line.strip}
          end
          next_line_index += 1
        end
      end
    end

    def likely_apple_api?(line, lines, index)
        # Improved heuristic: Check if the line starts with a capital letter and contains a period
        return true if line =~ /^[A-Z][a-zA-Z]*\./

        # Check surrounding comments for Apple-related keywords
        surrounding_lines = lines[[index-2, 0].max..[index+2, lines.length-1].min]
        apple_keywords = ["Apple", "UIKit", "Foundation", "Swift", "Objective-C"]
        surrounding_lines.any? { |l| l.strip.start_with?("//") && apple_keywords.any? { |kw| l.include?(kw) } }
      end

    
    def common_boilerplate?(line, lines)
        apple_docs = [] # Populate with common patterns from Apple documentation
        community_patterns = [] # Populate with community-contributed patterns

        def is_boilerplate(line, file_content, apple_docs)
            # Check against Apple documentation
            return true if apple_docs.include?(line)

            # Check for superclass references
            apple_classes = ["NSObject", "UIViewController"] # Extend this list as needed
            return true if apple_classes.any? { |cls| file_content.include?(": #{cls}") }
            
            def frequency_of_line_in_codebase(target_line)
                count = 0
                all_files = Dir.glob("**/*.swift").reject { |path| File.directory?(path) }
                all_files.each do |file|
                    lines = File.readlines(file)
                    count += lines.count { |line| line.strip == target_line.strip }
                end
                count
            end

            # Frequency analysis
            return true if frequency_of_line_in_codebase(line) > THRESHOLD

            # Community-driven patterns
#            return true if community_patterns.include?(line)

            # Machine learning (optional)
#            return true if ml_model_predict(line) == "boilerplate"

            false
        end

        # Check against new boilerplate detection logic
        return true if is_boilerplate(line, lines.join("\n"), apple_docs)

        # Existing logic for boilerplate patterns
        boilerplate_patterns = [
        'import Foundation',
          'import UIKit',
          'override func viewDidLoad() {',
          'super.viewDidLoad()',
          'required init?(coder aDecoder: NSCoder) {',
          'init(frame: CGRect) {',
          'super.init(frame: frame)',
          'super.init(coder: aDecoder)',
          'return',
          'case',
          'guard',
          'catch',
          'break',
          'else',
          /^import /,          # Import statements
          /^\/\/\//,          # Triple-slash comments
          /^\/\*/,            # Start of block comment
          /^\*\//,            # End of block comment
          /^$/,               # Empty lines
          /^@/,               # Annotations like @available
          /^#/,               # Preprocessor directives
          # Add other common patterns as needed...
            ]
            
            return true if boilerplate_patterns.any? { |pattern| line.match?(pattern) }
            
            # Ignore documentation comments followed by a declaration
            line_index = lines.index(line)
            if line.strip.start_with?('///') && line_index && line_index < lines.length - 1
                next_line = lines[line_index + 1]
                return true if next_line.match?(/^(class|struct|var|let|func|enum|@Published|@StateObject|@State|@ObservedObject)/)
            end
            
            # Ignore lines with only braces and parentheses
            return true if line.strip.match?(/^[\}\)\]]+$/)

            false
        end

    
    
    def check_unused_variables(file, lines)
        lines.each_with_index do |line, index|
            if line.include?('var ')
                var_name = line.split('var ')[1].split('=')[0].strip
                unless lines.join.include?(var_name)
                    @unused_vars << {file: file, line: index + 1, content: line.strip}
                end
            end
        end
    end
    
    def check_deep_nesting(file, lines)
        nesting_depth = 0
        lines.each_with_index do |line, index|
            nesting_depth += 1 if line.include?('{')
            nesting_depth -= 1 if line.include?('}')
            if nesting_depth > 3
                @deep_nesting << {file: file, line: index + 1, content: line.strip}
            end
        end
    end
    
    def check_large_files(file, lines)
        if lines.length > 300
            @large_files << {file: file, line_count: lines.length}
        end
    end
    
    def check_magic_numbers(file, lines)
        lines.each_with_index do |line, index|
          # Skip lines that are comments or have valid Swift constructs
          next if line.strip.start_with?('//', '/*', '*/', '///')
          next if line.strip.match?(/\d+\.\.\d+/)  # Ranges
          next if line.strip.match?(/for _ in \d+\.\.<\d+/)  # Loops with ranges
          next if line.strip.match?(/flatMap\{/)   # Flat mapping
          next if line.strip.match?(/#available\(.*\d+\.\d+.*\)/)  # Platform version checks
          next if line.strip.match?(/Color\(\..*?\)/)  # System colors
          next if line.strip.match?(/case \..*?\(value: \d+\)/)  # Enum cases with associated values
          next if line.strip.match?(/\[\d+\]/)  # Array indices
          next if line.strip.match?(/dictionary\[".*?"\] = \d+/)  # Dictionary assignments
          next if line.strip.match?(/let pi = 3\.14/)  # Common mathematical constants
          next if line.strip.match?(/value \* 2/)  # Common mathematical operations
          next if line.strip.match?(/@Available\(iOS \d+.*\)/)  # Attributes and property wrappers

          if line.match?(/\d+/) && !line.include?('var ') && !line.include?('let ')
            @magic_numbers << {file: file, line: index + 1, content: line.strip}
          end
        end
      end
    
    
    
    def check_indentation(file, lines)
        lines.each_with_index do |line, index|
            if line.include?("\t") && line.include?('  ')
                @inconsistent_indentation << {file: file, line: index + 1, content: line.strip}
            end
        end
    end
    
    def check_force_unwraps(file, lines)
        lines.each_with_index do |line, index|
            # Skip lines that are logical negations
            next if line.strip.match?(/!\w+\.\w+/)
            
            if line.include?('!')
                @force_unwraps << {file: file, line: index + 1, content: line.strip}
            end
        end
    end
    
end
# Instantiation and method calls
comment_analyzer = CommentAnalyzer.new
comment_analyzer.locate
comment_analyzer.display

code_quality_analyzer = CodeQualityAnalyzer.new
code_quality_analyzer.analyze

  puts "\nDuplicate Lines:".cyan
  code_quality_analyzer.duplicate_lines.each do |duplicate|
    puts "#{duplicate[:file]}: Line #{duplicate[:line]} duplicates Line #{duplicate[:duplicate_line]} - #{duplicate[:content]}"
  end

  puts "\nNon-CamelCase Variables:".magenta
  code_quality_analyzer.non_camel_case_vars.each do |var|
    puts "#{var[:file]}:#{var[:line]} - #{var[:content]}"
  end

  puts "\nUnused Variables:".blue
  code_quality_analyzer.unused_vars.each do |var|
    puts "#{var[:file]}:#{var[:line]} - #{var[:content]}"
  end

  puts "\nDeeply Nested Code:".yellow
  code_quality_analyzer.deep_nesting.each do |nest|
    puts "#{nest[:file]}:#{nest[:line]} - #{nest[:content]}"
  end

  puts "\nLarge Files:".green
  code_quality_analyzer.large_files.each do |large_file|
    puts "#{large_file[:file]}: Total lines - #{large_file[:line_count]}"
  end

  puts "\nMagic Numbers:".blue
  code_quality_analyzer.magic_numbers.each do |magic_number|
    puts "#{magic_number[:file]}:#{magic_number[:line]} - #{magic_number[:content]}"
  end

  puts "\nInconsistent Indentation:".cyan
  code_quality_analyzer.inconsistent_indentation.each do |indent|
    puts "#{indent[:file]}:#{indent[:line]} - #{indent[:content]}"
  end

  puts "\nForce Unwraps:".magenta
  code_quality_analyzer.force_unwraps.each do |unwrap|
    puts "#{unwrap[:file]}:#{unwrap[:line]} - #{unwrap[:content]}"
  end
