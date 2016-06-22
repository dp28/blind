require 'ostruct'
require_relative '../src/blind_map'

RSpec.describe BlindMap do
  let(:blind_map)      { BlindMap.new directory }
  let(:directory)      { OpenStruct.new files: files }
  let(:files)          { file_basenames.map { |file| "#{file}.#{file_extension}" } }
  let(:file_basenames) { %w(test A1 A2 A3 B1) }
  let(:file_extension) { 'extension' }

  describe '#unblinded_values' do
    subject(:unblinded_values) { blind_map.unblinded_values }

    it 'should return the file names in the directory, stripping file extensions' do
      expect(unblinded_values).to eq file_basenames
    end

    context 'when the file extension contains multiple "." characters' do
      let(:file_extension) { 'test.long.extension' }

      it 'should return the file names in the directory, stripping the complete file extensions' do
        expect(unblinded_values).to eq file_basenames
      end
    end

    context 'when there are multiple files with the same base and different extensions' do
      let(:file_basenames) { super() + super() }

      it 'should return each base file name only once' do
        expect(unblinded_values).to eq file_basenames.uniq
      end
    end
  end

  describe '#blinded_values' do
    subject(:blinded_values) { blind_map.blinded_values }

    it 'should return a range from 1 to the number of unblinded_values' do
      expect(blinded_values).to eq blind_map.unblinded_values.map.with_index { |_, i| (i + 1).to_s }
    end
  end

  describe '#to_h' do
    let(:hash) { blind_map.to_h }

    it 'should return a hash with blinded_values as its keys' do
      expect(hash.keys).to match_array blind_map.blinded_values
    end

    it 'should return a hash with unblinded_values as its values' do
      expect(hash.values).to match_array blind_map.unblinded_values
    end

    specify 'different BlindMap instances should return different mappings from blinded_value to ' \
      'unblinded_value for the same directory input' do
      expect(hash).not_to eq BlindMap.new(directory).to_h
    end

    specify 'a single BlindMap instance should always return the same mapping from blinded_value ' \
      'to unblinded_value for the same directory input' do
      expect(blind_map.to_h).to eq blind_map.to_h
    end
  end

  describe '#blind_file' do
    let(:unblinded_part) { file_basenames.first }
    let(:file_basename)  { unblinded_part }
    let(:file_name)      { "#{file_basename}.#{file_extension}" }

    it 'should replace the basename of the file name' do
      expect(blind_map.blind_file(file_name)).not_to include file_basename
    end

    it 'should not change the file extension' do
      expect(blind_map.blind_file(file_name)).to include file_extension
    end

    context 'if the unblinded part appears in a directory name' do
      let(:file_basename) { "#{unblinded_part}/#{unblinded_part}" }

      it 'should only change the file name, not the directory' do
        expect(blind_map.blind_file(file_name)).to match %r{#{unblinded_part}\/.+#{file_extension}}
      end
    end
  end

  describe '#unblind_file' do
    let(:file_basename)     { file_basenames.first }
    let(:blinded_file_name) { "#{blinded_part}.#{file_extension}" }

    let(:blinded_part) do
      blind_map.to_h.detect { |_blinded, unblinded| unblinded == file_basename }.first
    end

    it 'should replace the blinded basename of the file name' do
      expect(blind_map.unblind_file(blinded_file_name)).to include file_basename
    end

    it 'should not change the file extension' do
      expect(blind_map.unblind_file(blinded_file_name)).to include file_extension
    end

    context 'if the blinded part appears in a directory name' do
      it 'should only change the file name, not the directory' do
        unblinded = blind_map.unblind_file "#{blinded_part}a/#{blinded_part}.#{file_extension}"
        expect(unblinded).to match %r{#{blinded_part}a\/.+#{file_extension}}
      end
    end
  end
end
