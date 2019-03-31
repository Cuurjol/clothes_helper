class Garment
  attr_reader :name, :type, :temperature_range

  def initialize(name, type, temperature_range)
    @name = name
    @type = type
    @temperature_range = temperature_range
  end

  def suitable_for_weather?(temperature)
    @temperature_range.include?(temperature)
  end

  def to_s
    I18n.t('garment.information', name: @name, type: @type, begin: @temperature_range.begin, end: @temperature_range.end)
  end
end