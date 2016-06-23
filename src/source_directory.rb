require_relative './error/invalid_directory_error'
require_relative './blind'

class SourceDirectory
  attr_reader :path

  def initialize(path)
    @path = path
    validate
  end

  def files
    @files ||= all_files.select(&method(:blindable?))
  end

  def already_blinded?
    all_files.any? { |file| !blindable? file }
  end

  private

  def all_files
    @all_files ||= Dir[File.join(path, '/*')].select { |file| File.file? file }
  end

  def blindable?(file)
    file !~ /#{Blind::BLIND_FILE}$/
  end

  def validate
    raise Error::InvalidDirectoryError, path if Dir[path].empty?
  end
end
