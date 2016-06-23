require_relative '../src/source_directory'
require_relative '../src/error/invalid_directory_error'

RSpec.describe SourceDirectory do
  subject(:source_directory) { SourceDirectory.new path }

  let(:path)                 { 'unused' }
  let(:files)                { ['test.rb', 'source_directory.rb'] }
  let(:blind_file)           { Blind::BLIND_FILE }
  let(:specified_blind_file) { '/path/to/' + blind_file }

  before do
    allow(Dir).to receive(:[]).with(path).and_return [path]
    allow(Dir).to receive(:[]).with("#{path}/*").and_return files
    allow(File).to receive(:file?).and_return true
  end

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

  describe '#already_blinded?' do
    subject { source_directory.already_blinded? }
    context "when the directory does not include the blind map file (#{Blind::BLIND_FILE})" do
      it { should be_falsy }
    end

    context "when the directory does include the blind map file (#{Blind::BLIND_FILE})" do
      let(:files) { super().push blind_file }
      it { should be_truthy }
    end

    context 'when the directory does include blind file with a fully specified path' do
      let(:files) { super().push specified_blind_file }
      it { should be_truthy }
    end
  end

  describe '#path' do
    it 'should return the path passed in to the constructor' do
      expect(source_directory.path).to eq path
    end
  end

  describe '#files' do
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

    context 'and there is already a blind map file in the directory' do
      let(:files) { super().push blind_file }

      it 'should not return the blind file' do
        expect(source_directory.files).not_to include blind_file
      end

      context 'and the blind file has a fully specified path' do
        let(:files) { super().push specified_blind_file }

        it 'should not return the blind file' do
          expect(source_directory.files).not_to include specified_blind_file
        end
      end
    end
  end
end
