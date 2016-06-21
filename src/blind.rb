require 'json'

class Blind

  BLIND_FILE = 'unblind.json'

  def call(directory_name, dry_run: false)
    directory = find_directory directory_name
    blind_map = build_unblind_map files_in_dir(directory_name)
    rename_files directory, blind_map unless dry_run
    save_as_json directory, blind_map
  end

private

  def extract_file_name_to_change(file_name)
    basename = File.basename file_name
    /([^\.]*)\..*/.match(basename)[1]
  end

  def replace_names(file_names)
    file_names.map.with_index do |file_name, index|
      file_name.sub /[^\.]+/, "#{index + 1}"
    end
  end

  def build_unblind_map(file_names)
    old_file_names = file_names.shuffle.map { |f| File.basename f }
    new_file_names = replace_names old_file_names
    old_file_names.zip(new_file_names).each_with_object({}) do |(old_file, new_file), map|
      map[new_file] = old_file
    end
  end

  def files_in_dir(directory_name)
    file_pattern = directory_name.sub(/\/$/, '') + '/*'
    Dir[file_pattern]
  end

  def save_as_json(directory, blind_map)
    json        = JSON.pretty_generate blind_map
    output_file = File.join directory, BLIND_FILE
    File.write output_file, json
  end

  def find_directory(directory_name)
    Dir[directory_name].tap do |directory|
      raise "'#{ARGV.first}' is not a directory" if !directory || directory.empty?
    end
  end

  def rename_files(directory_name, file_name_map)
    file_name_map.each do |new_name, old_name|
      File.rename File.join(directory_name, old_name), File.join(directory_name, new_name)
    end
  end

end
