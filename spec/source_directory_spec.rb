require_relative '../src/source_directory'
require_relative '../src/error/invalid_directory_error'

RSpec.describe SourceDirectory do
  subject(:source_directory) { SourceDirectory.new path }
  let(:path) { File.dirname(__FILE__).sub(/spec$/, 'src') }

  describe '.new' do
    it 'should return a new SourceDirectory' do
      expect(SourceDirectory.new(path)).to be_a SourceDirectory
    end

    context 'when the passed in path is not a directory' do
      let(:path) { '/this/really/should/not/be/a/directory' }

      it 'should raise an InvalidDirectoryError' do
        expect { SourceDirectory.new(path) }.to raise_error Error::InvalidDirectoryError
      end
    end
  end

  describe '#path' do
    it 'should return the path passed in to the constructor' do
      expect(source_directory.path).to eq path
    end
  end

  describe '#files' do
    it 'should return the files in the directory' do
      files = ['blind.rb', 'source_directory.rb'].map { |file| File.join(path, file) }
      expect(source_directory.files).to include(*files)
    end

    it 'should not return the subdirectories in the direcory' do
      expect(source_directory.files).not_to include(File.join(path, 'error'))
    end
  end
end
