require_relative './blind_error'

module Error
  class InvalidDirectoryError < BlindError
    attr_reader :path

    def initialize(path)
      super
      @path = path
    end

    def message
      "'#{path}' is not a directory"
    end
  end
end
