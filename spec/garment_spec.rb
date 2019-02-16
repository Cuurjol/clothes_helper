require 'rspec'
require_relative '../lib/garment'

describe Garment do
  let(:garment) { Garment.new("Халат", "Верхняя одежда", Range.new(15, 25)) }

  it 'assigns instance variables' do
    expect(garment.name).to eq "Халат"
    expect(garment.type).to eq "Верхняя одежда"
    expect(garment.temperature_range).to eq Range.new(15, 25)
  end

  it 'returns a positive answer to the question: "Is the garment suitable for weather?"' do
    expect(garment.suitable_for_weather?(20)).to be_truthy
  end

  it 'returns a negative answer to the question: "Is the garment suitable for weather?"' do
    expect(garment.suitable_for_weather?(-10)).to be_falsey
  end
end
