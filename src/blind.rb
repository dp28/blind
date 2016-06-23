require 'json'
require_relative './source_directory'
require_relative './blind_map'
require_relative './error/already_blinded_error'

class Blind
  BLIND_FILE = 'unblind.json'.freeze

  attr_reader :directory, :blind_map

  def call(directory_path, dry_run: false)
    @directory = SourceDirectory.new directory_path
    @blind_map = BlindMap.new directory
    raise Error::AlreadyBlindedError, directory if directory.already_blinded?
    dry_run ? perform_dry_run : perform
  end

  private

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
    File.join directory.path, BLIND_FILE
  end

  def output
    JSON.pretty_generate blind_map.to_h
  end
end
