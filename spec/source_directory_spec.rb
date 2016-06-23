require_relative '../src/source_directory'
require_relative '../src/error/invalid_directory_error'

RSpec.describe SourceDirectory do
  subject(:source_directory) { SourceDirectory.new path }
  let(:path) { 'unused' }

  before { allow(Dir).to receive(:[]).with(path).and_return [path] }

  describe '.new' do
    it 'should return a new SourceDirectory' do
      expect(SourceDirectory.new(path)).to be_a SourceDirectory
    end

    context 'when the passed in path is not a directory' do
      before { allow(Dir).to receive(:[]).with(path).and_return [] }

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
    let(:files) { ['test.rb', 'source_directory.rb'] }
    before do
      allow(Dir).to receive(:[]).with("#{path}/*").and_return files
      allow(File).to receive(:file?).and_return true
    end

    it 'should return the files in the directory' do
      expect(source_directory.files).to eq files
    end

    context 'and the directory contains subdirectories' do
      let(:files)        { super().push subdirectory }
      let(:subdirectory) { 'directory' }

      before { allow(File).to receive(:file?).and_return false }

      it 'should not return the subdirectories in the directory' do
        expect(source_directory.files).not_to include subdirectory
      end
    end
  end
end
