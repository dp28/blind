require 'json'
require_relative './source_directory'
require_relative './blind_map'

class Blind
  BLIND_FILE = 'unblind.json'.freeze

  attr_reader :directory, :blind_map

  def call(directory_path, dry_run: false)
    @directory = SourceDirectory.new directory_path
    @blind_map = BlindMap.new directory
    rename_files unless dry_run
    save_as_json
  end

  private

  def save_as_json
    json        = JSON.pretty_generate blind_map.to_h
    output_file = File.join directory.path, BLIND_FILE
    File.write output_file, json
  end

  def rename_files
    directory.files.each do |file_name|
      File.rename file_name, blind_map.blind_file(file_name)
    end
  end
end
