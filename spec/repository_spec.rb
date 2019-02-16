require 'rspec'
require 'fileutils'
require 'rexml/document'
require_relative '../lib/garment'
require_relative '../lib/wardrobe'
require_relative '../lib/repository'

describe Repository do
  let(:xml_file_path) { File.absolute_path(File.join(data_folder_path, 'clothing.xml')) }
  let(:data_folder_path) { File.join(Dir.pwd, 'spec', 'fixtures') }
  let(:repository) { Repository.new(xml_file_path) }

  before(:example) do
    FileUtils.mkdir_p(data_folder_path)
    FileUtils.cp(File.absolute_path('./data/clothing.xml'), data_folder_path)
    @quantity = repository.instance_variable_get(:@data_hash).size
  end

  after(:example) do
    FileUtils.rm(xml_file_path)
    FileUtils.remove_dir(data_folder_path)
  end

  describe '#add' do
    it 'adds a new garment node' do
      garment = Garment.new('Свитер', 'Верхняя одежда', Range.new(-15, 0))
      repository.add(garment)
      expect(repository.instance_variable_get(:@data_hash).size).to be > @quantity
    end
  end

  describe '#delete' do
    it 'deletes an existing garment node' do
      wardrobe = Wardrobe.new(repository.get_data)
      garment = wardrobe.search(by: :name, value: 'Панама')
      repository.delete(garment)
      expect(repository.instance_variable_get(:@data_hash).size).to be < @quantity
    end

    it 'tries to delete a non existing garment node' do
      garment = Garment.new('Красная куртка', 'Верхняя одежда', Range.new(0, 10))
      repository.delete(garment)
      expect(repository.instance_variable_get(:@data_hash).size).to eq @quantity
    end
  end

  describe 'private methods' do
    describe '#left_limit_range' do
      it 'returns the starting value of temperature range' do
        line = '(-20, 0)'
        expect(repository.send(:left_limit_range, line)).to eq -20
      end
    end

    describe '#right_limit_range' do
      it 'returns the ending value of temperature range' do
        line = '(-20, 0)'
        expect(repository.send(:right_limit_range, line)).to eq 0
      end
    end

    describe '#create_information_array' do
      it 'returns the created information' do
        garment = Garment.new('Свитер', 'Верхняя одежда', Range.new(-15, 0))
        test_information = [garment.name, garment.type, '(-15, 0)']
        expect(repository.send(:create_information_array, garment)).to eq test_information
      end
    end
  end
end
