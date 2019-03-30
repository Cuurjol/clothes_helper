require 'rspec'
require 'fileutils'
require 'rexml/document'
require_relative '../lib/garment'
require_relative '../lib/wardrobe'
require_relative '../lib/repository'

describe Repository do
  before(:all) do
    document_xml = REXML::Document.new('<?xml version="1.0" encoding="utf-8"?>')
    document_xml.add_element('clothing')
    garment_count = rand(1..10)

    1.upto(garment_count) do |id|
      name = 'Random name ' + rand(1..100).to_s
      type = 'Random type ' + rand(1..100).to_s
      temperature = "(#{rand(-100..0)}, +#{rand(1..100)})"

      garment_node = document_xml.root.add_element('garment')
      garment_node.add_attribute('id', id.to_s)

      name_node = garment_node.elements.add('name')
      name_node.text = name

      type_node = garment_node.elements.add('type')
      type_node.text = type

      temperature_node = garment_node.elements.add('temperature')
      temperature_node.text = temperature
    end

    data_folder_path = File.join(Dir.pwd, 'spec', 'fixtures')
    FileUtils.mkdir_p(data_folder_path)
    FileUtils.touch(File.join(data_folder_path, 'clothing.xml'))
    xml_file_path = File.absolute_path(File.join(data_folder_path, 'clothing.xml'))

    file = File.new(File.join(data_folder_path, 'clothing.xml'), 'w:UTF-8')
    formatter = REXML::Formatters::Pretty.new
    formatter.compact = true
    formatter.write(document_xml, file)
    file.close

    @repository = Repository.new(xml_file_path)
  end

  before(:each) do
    @quantity = @repository.instance_variable_get(:@data_hash).size
  end

  after(:all) do
    data_folder_path = File.join(Dir.pwd, 'spec', 'fixtures')
    xml_file_path = File.absolute_path(File.join(data_folder_path, 'clothing.xml'))
    FileUtils.rm(xml_file_path)
    FileUtils.remove_dir(data_folder_path)
  end

  describe '#add' do
    it 'adds a new garment node' do
      garment = Garment.new('Свитер', 'Верхняя одежда', Range.new(-15, 0))
      @repository.add(garment)
      expect(@repository.instance_variable_get(:@data_hash).size).to be > @quantity
    end
  end

  describe '#delete' do
    it 'deletes an existing garment node' do
      wardrobe = Wardrobe.new(@repository.get_data)
      garment = wardrobe.clothing.sample
      @repository.delete(garment)
      expect(@repository.instance_variable_get(:@data_hash).size).to be < @quantity
    end

    it 'tries to delete a non existing garment node' do
      garment = Garment.new('Random garment qwerty', 'Random type qwerty', Range.new(-150_000, 250_000))
      @repository.delete(garment)
      expect(@repository.instance_variable_get(:@data_hash).size).to eq @quantity
    end
  end

  describe 'private methods' do
    describe '#left_limit_range' do
      it 'returns the starting value of temperature range' do
        line = '(-20, 0)'
        expect(@repository.send(:left_limit_range, line)).to eq -20
      end
    end

    describe '#right_limit_range' do
      it 'returns the ending value of temperature range' do
        line = '(-20, 0)'
        expect(@repository.send(:right_limit_range, line)).to eq 0
      end
    end

    describe '#create_information_array' do
      it 'returns the created information' do
        garment = Garment.new('Свитер', 'Верхняя одежда', Range.new(-15, 0))
        test_information = [garment.name, garment.type, '(-15, 0)']
        expect(@repository.send(:create_information_array, garment)).to eq test_information
      end
    end
  end
end
