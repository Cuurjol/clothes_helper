require 'rspec'
require 'rexml/document'
require_relative '../lib/repository'
require_relative '../lib/garment'
require_relative '../lib/wardrobe'

describe Wardrobe do
  let(:xml_file_path) { File.absolute_path(File.join(data_folder_path, 'clothing.xml')) }
  let(:data_folder_path) { File.join(Dir.pwd, 'spec', 'fixtures') }
  let(:wardrobe) { Wardrobe.new(@repository.get_data) }

  before(:example) do
    FileUtils.mkdir_p(data_folder_path)
    FileUtils.cp(File.absolute_path('./data/clothing.xml'), data_folder_path)
    @repository = Repository.new(xml_file_path)
  end

  after(:example) do
    FileUtils.rm(xml_file_path)
    FileUtils.remove_dir(data_folder_path)
  end

  describe '#new' do
    it 'assigns instance variables' do
      expect(wardrobe.clothing).not_to be_empty
    end

    it 'assigns nil instance variables' do
      wardrobe = Wardrobe.new
      expect(wardrobe.clothing).to be_empty
    end
  end

  describe 'Add/delete methods' do
    let(:garment) { Garment.new("Халат", "Верхняя одежда", Range.new(15, 25)) }
    let!(:quantity) { wardrobe.clothing.size }

    describe '#add' do
      it 'adds a new garment to the wardrobe' do
        wardrobe.add(garment)
        expect(wardrobe.clothing.size).to be > quantity
      end
    end

    describe '#delete' do
      it 'deletes the garment from the wardrobe' do
        garment = wardrobe.search(by: :name, value: "Пальто")
        wardrobe.delete(garment)
        expect(wardrobe.clothing.size).to be < quantity
      end

      it 'deletes the non existing garment from the wardrobe' do
        wardrobe.delete(garment)
        expect(wardrobe.clothing.size).to eq quantity
      end
    end
  end

  describe '#search' do
    it 'returns first garment called "Шлепанцы"' do
      expect(wardrobe.search(by: :name, value: "Шлепанцы")).to be_truthy
    end

    it 'doesn\'t returns first garment with a type called "Халат"' do
      expect(wardrobe.search(by: :type, value: "Халат")).to be_falsey
    end

    it 'returns first garment with a temperature range of -5 to +10' do
      expect(wardrobe.search(by: :temperature_range, value: Range.new(-5, 10))).to be_truthy
    end
  end

  describe '#search_all' do
    it 'returns all garments with a type called "Обувь"' do
      expect(wardrobe.search_all(by: :type, value: "Обувь")).not_to be_empty
    end

    it 'doesn\'t return all garments with a temperature range of -5 to 5' do
      expect(wardrobe.search_all(by: :temperature_range, value: Range.new(-5, 5))).to be_empty
    end
  end

  describe '#what_to_wear' do
    it 'returns a final clothing' do
      expect(wardrobe.what_to_wear(20)).not_to be_empty
    end

    it 'doesn\'t return a final clothing' do
      expect(wardrobe.what_to_wear(-30)).to be_empty
    end
  end

  describe 'private methods' do
    describe '#clothing_type' do
      it 'returns clothing of the same type' do
        expect(wardrobe.send(:clothing_type)).not_to be_empty
      end
    end
  end
end
