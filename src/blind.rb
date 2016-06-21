require 'json'
require_relative './source_directory'

class Blind
  BLIND_FILE = 'unblind.json'.freeze

  attr_reader :directory

  def call(directory_path, dry_run: false)
    @directory = SourceDirectory.new directory_path
    blind_map = build_unblind_map
    rename_files blind_map unless dry_run
    save_as_json blind_map
  end

  private

  def extract_file_name_to_change(file_name)
    basename = File.basename file_name
    /([^\.]*)\..*/.match(basename)[1]
  end

  def replace_names
    directory.files.map.with_index do |file_name, index|
      file_name.sub(/[^\.]+/, (index + 1).to_s)
    end
  end

  def build_unblind_map
    old_file_names = directory.files.shuffle.map { |f| File.basename f }
    new_file_names = replace_names
    old_file_names.zip(new_file_names).each_with_object({}) do |(old_file, new_file), map|
      map[new_file] = old_file
    end
  end

  def save_as_json(blind_map)
    json        = JSON.pretty_generate blind_map
    output_file = File.join directory.path, BLIND_FILE
    File.write output_file, json
  end

  def rename_files(file_name_map)
    file_name_map.each do |new_name, old_name|
      File.rename File.join(directory.path, old_name), File.join(directory.path, new_name)
    end
  end
end
