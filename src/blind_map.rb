class BlindMap
  attr_reader :directory

  def initialize(directory)
    @directory        = directory
    @blind_to_unblind = blinded_values.zip(unblinded_values.shuffle).to_h
  end

  def unblinded_values
    @unblinded_values ||= directory.files.map(&method(:name_without_extension)).uniq
  end

  def blinded_values
    @blinded_values ||= (1..unblinded_values.length).to_a.map(&:to_s)
  end

  def to_h
    blind_to_unblind
  end

  def each_file
    directory.files.each { |file| yield blind_file(file), file }
  end

  def blind_file(full_file_path)
    swap_file_names full_file_path, unblind_to_blind
  end

  def unblind_file(full_file_path)
    swap_file_names full_file_path, blind_to_unblind
  end

  private

  attr_reader :blind_to_unblind

  def name_without_extension(file)
    File.basename(file).sub(/\..+/, '')
  end

  def unblind_to_blind
    @unblind_to_blind ||= blind_to_unblind.to_a.map(&:reverse).to_h
  end

  def swap_file_names(full_file_path, name_map)
    file_name = name_without_extension full_file_path
    replace_file_name full_file_path, file_name, name_map[file_name]
  end

  def replace_file_name(full_file_path, old_name, new_name)
    full_file_path.sub(%r{#{old_name}([^\/]+)$}, "#{new_name}\\1")
  end
end
