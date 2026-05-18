# encoding: utf-8
# Run the tests in 'tests/'
require 'fileutils'
require 'open3'

class Test
  attr_reader :source_file

  def initialize(source_file)
    @source_file = source_file
  end

  def base_name
    File.basename(@source_file, '.*')
  end

  def generated_name
    File.join(File.dirname(@source_file), base_name + '.v')
  end

  def rocq_of_ocaml_cmd(extra_args = [])
    local_executable = '_build/default/src/rocqOfOCaml.exe'
    rocq_of_ocaml =
      ARGV[0] == '--with-coverage' ?
        ['dune', 'exec', '--instrument-with', 'bisect_ppx', 'src/rocqOfOCaml.exe', '--'] :
        [File.executable?(local_executable) ? local_executable : 'rocq-of-ocaml']
    cmd = [*rocq_of_ocaml, '-output', '/dev/stdout']
    configuration_file = File.join(File.dirname(@source_file), base_name + '.json')
    cmd.push('-config', configuration_file) if File.exist?(configuration_file)
    cmd.push(*extra_args)
    cmd.push(@source_file)
  end

  def rocq_of_ocaml
    # We remove the fist line which is a success message
    cmd = rocq_of_ocaml_cmd
    output, error, status = Open3.capture3(*cmd)
    unless status.success?
      warn "Command failed: #{cmd.join(' ')}"
      warn error unless error.empty?
      raise "Command failed"
    end
    output.force_encoding("utf-8").lines.drop(1).join
  end

  def reference
    file_name = generated_name
    FileUtils.touch file_name unless File.exist?(file_name)
    File.read(file_name, :encoding => 'utf-8')
  end

  # Update the reference snapshot file.
  def update
    output = rocq_of_ocaml
    file_name = generated_name
    File.write(file_name, output)
  end

  def check
    # Uncomment the following line to update the test snapshots.
    # update
    rocq_of_ocaml == reference
  end

  def rocq_cmd
    "rocq c -R tests Tests -R proofs RocqOfOCaml -impredicative-set #{generated_name}"
  end

  def rocq
    system("#{rocq_cmd} 2>/dev/null")
    return $?.exitstatus == 0
  end

  def extraction_cmd
    disable_fatal_warnings = "-lflags '-warn-error -a'"
    "cd tests/extraction && rocq c -R .. Tests -R ../../proofs RocqOfOCaml -impredicative-set extract.v && ocamlbuild #{disable_fatal_warnings} #{base_name}.byte && ./#{base_name}.byte"
  end

  def extraction
    FileUtils.rm_rf(["tests/extraction"])
    FileUtils.mkdir_p("tests/extraction")
    File.open("tests/extraction/extract.v", "w") do |f|
      f << <<-EOF
Require Import Tests.#{base_name}.

Recursive Extraction Library #{base_name}.
      EOF
    end
    system("(#{extraction_cmd}) >/dev/null")
    return $?.exitstatus == 0
  end
end

class NegativeTest < Test
  def initialize(source_file, json_mode = false)
    super(source_file)
    @json_mode = json_mode
  end

  def error_file_name
    @source_file + '.errors'
  end

  def snapshot_name
    File.join(File.dirname(@source_file), base_name + '.errors')
  end

  def rocq_of_ocaml_cmd
    super(@json_mode ? ['-json-mode'] : [])
  end

  def normalize(output)
    output.force_encoding('utf-8').gsub(/\e\[[0-9;]*m/, '')
  end

  def rocq_of_ocaml_error
    FileUtils.rm_f(error_file_name)
    output, error, status = Open3.capture3(*rocq_of_ocaml_cmd)
    return nil if status.success?
    content =
      if @json_mode
        return nil unless File.exist?(error_file_name)
        File.read(error_file_name, :encoding => 'utf-8')
      else
        output + error
      end
    normalize(content)
  ensure
    FileUtils.rm_f(error_file_name)
  end

  def reference
    FileUtils.touch snapshot_name unless File.exist?(snapshot_name)
    File.read(snapshot_name, :encoding => 'utf-8')
  end

  def update
    File.write(snapshot_name, rocq_of_ocaml_error)
  end

  def check
    update if ENV['UPDATE_ERROR_SNAPSHOTS'] == '1'
    rocq_of_ocaml_error == reference
  end
end

class DefaultOutputTest < Test
  def generated_default_file
    without_extension = File.join(File.dirname(@source_file), base_name)
    extension = File.extname(@source_file)
    new_extension = extension == '.mli' ? '_mli.v' : '.v'
    File.join(File.dirname(without_extension), File.basename(without_extension).capitalize + new_extension)
  end

  def rocq_of_ocaml_cmd
    local_executable = '_build/default/src/rocqOfOCaml.exe'
    rocq_of_ocaml =
      ARGV[0] == '--with-coverage' ?
        ['dune', 'exec', '--instrument-with', 'bisect_ppx', 'src/rocqOfOCaml.exe', '--'] :
        [File.executable?(local_executable) ? local_executable : 'rocq-of-ocaml']
    [*rocq_of_ocaml, @source_file]
  end

  def check
    FileUtils.rm_f(generated_default_file)
    output, error, status = Open3.capture3(*rocq_of_ocaml_cmd)
    status.success? &&
      File.exist?(generated_default_file) &&
      (output + error).include?(generated_default_file)
  ensure
    FileUtils.rm_f(generated_default_file)
  end
end

class NoInputTest < Test
  def initialize
    super('no input')
  end

  def rocq_of_ocaml_cmd
    local_executable = '_build/default/src/rocqOfOCaml.exe'
    rocq_of_ocaml =
      ARGV[0] == '--with-coverage' ?
        ['dune', 'exec', '--instrument-with', 'bisect_ppx', 'src/rocqOfOCaml.exe', '--'] :
        [File.executable?(local_executable) ? local_executable : 'rocq-of-ocaml']
    rocq_of_ocaml
  end

  def check
    output, error, status = Open3.capture3(*rocq_of_ocaml_cmd)
    status.success? && (output + error).include?('Usage:')
  end
end

class Tests
  def initialize(source_files)
    @tests =
      source_files
        .sort_by {|source_file| source_file.respond_to?(:source_file) ? source_file.source_file : source_file }
        .map {|source_file| source_file.is_a?(Test) ? source_file : Test.new(source_file) }
    @valid_tests = 0
    @invalid_tests = 0
  end

  def print_result(result)
    if result
      @valid_tests += 1
      print " \e[1;32m✓\e[0m "
    else
      @invalid_tests += 1
      print " \e[31m✗\e[0m "
    end
  end

  def check
    puts "\e[1mChecking '.v':\e[0m"
    for test in @tests do
      print_result(test.check)
      puts test.rocq_of_ocaml_cmd.join(" ")
    end
  end

  def rocq
    puts "\e[1mRunning Rocq (compiles the reference files):\e[0m"
    for test in @tests do
      print_result(test.rocq)
      puts test.rocq_cmd
    end
  end

  def extraction
    puts "\e[1mCompiling and running the extracted programs:\e[0m"
    for test in @tests do
      if File.extname(test.source_file) != ".mli" then
        print_result(test.extraction)
        puts test.extraction_cmd
      end
    end
  end

  def print_summary
    puts
    puts "Total: #{@valid_tests} / #{@valid_tests + @invalid_tests}."
  end

  def invalid?
    @invalid_tests != 0
  end
end

test_files = Dir.glob('tests/*.ml*').select do |file_name|
  not file_name.include?("disabled")
end
tests = Tests.new(test_files)
tests.check
puts
tests.rocq

negative_tests = Tests.new([
  NegativeTest.new('tests/errors/legacy_attribute.ml'),
  NegativeTest.new('tests/errors/lazy_pattern.ml'),
  NegativeTest.new('tests/errors/polymorphic_variants.ml'),
  NegativeTest.new('tests/errors/optional_default.ml'),
  NegativeTest.new('tests/errors/unsupported_expressions.ml'),
  NegativeTest.new('tests/errors/unsupported_signature.mli'),
  NegativeTest.new('tests/errors/unknown_attribute_json.ml', true)
])
negative_tests.check

cli_tests = Tests.new([
  DefaultOutputTest.new('tests/top_level_definition.ml'),
  DefaultOutputTest.new('tests/functor.mli'),
  NoInputTest.new
])
cli_tests.check

# We do not test the extraction for now as it fails due to axioms. We will see
# how to deal with it latter.
# tests.extraction
tests.print_summary
negative_tests.print_summary
cli_tests.print_summary

exit(1) if tests.invalid? || negative_tests.invalid? || cli_tests.invalid?
