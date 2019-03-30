require 'rspec'
require 'rexml/document'
require_relative '../lib/repository'
require_relative '../lib/garment'
require_relative '../lib/wardrobe'

describe Wardrobe do
  before(:all) do
    garment_array = [
      Garment.new('Шапка-ушанка', 'Головной убор', Range.new(-20, -5)),
      Garment.new('Кроссовки', 'Обувь', Range.new(0, 15)),
      Garment.new('Джинсы', 'Штаны', Range.new(-5, 15)),
      Garment.new('Пальто', 'Верхняя одежда', Range.new(-5, 10)),
      Garment.new('Шлепанцы', 'Обувь', Range.new(20, 40)),
      Garment.new('Шорты-карго', 'Шорты', Range.new(20, 30)),
      Garment.new('Плавки', 'Шорты', Range.new(30, 40)),
      Garment.new('Панама', 'Головной убор', Range.new(30, 40)),
      Garment.new('Белая футболка', 'Футболка', Range.new(20, 40))
    ]

    @wardrobe = Wardrobe.new(garment_array)
  end

  describe '#new' do
    it 'assigns instance variables' do
      expect(@wardrobe.clothing).not_to be_empty
    end

    it 'assigns nil instance variables' do
      wardrobe = Wardrobe.new
      expect(wardrobe.clothing).to be_empty
    end
  end

  describe 'Add/delete methods' do
    let!(:quantity) { @wardrobe.clothing.size }

    describe '#add' do
      it 'adds a new garment to the wardrobe' do
        @wardrobe.add(Garment.new('Кепка Adidas', 'Головной убор', Range.new(10, 30)))
        expect(@wardrobe.clothing.size).to be > quantity
      end
    end

    describe '#delete' do
      it 'deletes the garment from the wardrobe' do
        garment = @wardrobe.clothing.first
        @wardrobe.delete(garment)
        expect(@wardrobe.clothing.size).to be < quantity
      end

      it 'deletes the non existing garment from the wardrobe' do
        @wardrobe.delete(Garment.new('Random garment', 'Random type', Range.new(-5, 5)))
        expect(@wardrobe.clothing.size).to eq quantity
      end
    end
  end

  describe '#search' do
    it 'returns first garment called "Шлепанцы"' do
      expect(@wardrobe.search(by: :name, value: 'Шлепанцы')).to be_truthy
    end

    it 'doesn\'t return first garment with a type called "Халат"' do
      expect(@wardrobe.search(by: :type, value: 'Халат')).to be_falsey
    end

    it 'returns first garment with a temperature range of -5 to +10' do
      expect(@wardrobe.search(by: :temperature_range, value: Range.new(-5, 10))).to be_truthy
    end
  end

  describe '#search_all' do
    it 'returns all garments with a type called "Обувь"' do
      expect(@wardrobe.search_all(by: :type, value: 'Обувь')).not_to be_empty
    end

    it 'doesn\'t return all garments with a temperature range of -5 to 5' do
      expect(@wardrobe.search_all(by: :temperature_range, value: Range.new(-5, 5))).to be_empty
    end
  end

  describe '#what_to_wear' do
    it 'returns a final clothing' do
      expect(@wardrobe.what_to_wear(20)).not_to be_empty
    end

    it 'doesn\'t return a final clothing' do
      expect(@wardrobe.what_to_wear(-30)).to be_empty
    end
  end

  describe 'private methods' do
    describe '#clothing_type' do
      it 'returns clothing of the same type' do
        expect(@wardrobe.send(:clothing_type)).not_to be_empty
      end
    end
  end
end
