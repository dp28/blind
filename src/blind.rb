require_relative './source_directory'
require_relative './blind_map'
require_relative './error/already_blinded_error'

class Blind
  BLIND_FILE  = 'unblind.csv'.freeze
  DEFAULT_DIR = '.'.freeze

  attr_reader :directory, :blind_map

  def call(*args)
    return print_usage if show_help?(args)
    @directory = SourceDirectory.new find_directory_path(args)
    @blind_map = BlindMap.new directory
    raise Error::AlreadyBlindedError, directory if directory.already_blinded?
    dry_run?(args) ? perform_dry_run : perform
  end

  private

  CSV_HEADERS = 'Blinded file name, Unblinded file name'.freeze

  def perform_dry_run
    puts "Dry run - not changing file names\n\nWould change file names to:\n\n"
    longest_file_name_length = directory.files.map(&:length).max
    blind_map.each_file do |blinded_file, unblinded_file|
      puts "#{unblinded_file.ljust(longest_file_name_length)} -> #{blinded_file}"
    end
    puts "\nWould save all renames to #{output_file}"
  end

  def perform
    rename_files
    save_output
    puts "Renamed files and saved the record of changes to '#{output_file}'"
  end

  def rename_files
    blind_map.each_file do |blinded_file, unblinded_file|
      File.rename unblinded_file, blinded_file
    end
  end

  def save_output
    File.write output_file, output
  end

  def output_file
    @output_file ||= File.join directory.path, BLIND_FILE
  end

  def output
    csv = blind_map.to_h.map { |blind, unblind| "\"#{blind}\",\"#{unblind}\"" }
    csv.unshift [CSV_HEADERS]
    csv.join "\n"
  end

  def find_directory_path(args)
    args.detect { |arg| arg !~ /^--/ } || DEFAULT_DIR
  end

  def dry_run?(args)
    args.include? '--dry-run'
  end

  def show_help?(args)
    args.include?('-h') || args.include?('--help')
  end

  def print_usage
    this_directory = File.dirname __FILE__
    usage          = File.join this_directory, '../usage.md'
    puts File.read(usage)
  end
end
