# encoding: utf-8
# Run the tests in 'tests/'
require 'fileutils'

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

  def rocq_of_ocaml_cmd
    local_executable = '_build/default/src/rocqOfOCaml.exe'
    rocq_of_ocaml =
      ARGV[0] == '--with-coverage' ?
        ['dune', 'exec', '--instrument-with', 'bisect_ppx', 'src/rocqOfOCaml.exe', '--'] :
        [File.executable?(local_executable) ? local_executable : 'rocq-of-ocaml']
    cmd = [*rocq_of_ocaml, '-output', '/dev/stdout', @source_file]
  end

  def rocq_of_ocaml
    # We remove the fist line which is a success message
    output = IO.popen(rocq_of_ocaml_cmd, :external_encoding => "utf-8").read.split("\n")[1..-1].join("\n") + "\n"
    output
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

class Tests
  def initialize(source_files)
    @tests = source_files.sort.map {|source_file| Test.new(source_file) }
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
# We do not test the extraction for now as it fails due to axioms. We will see
# how to deal with it latter.
# tests.extraction
tests.print_summary

exit(1) if tests.invalid?
