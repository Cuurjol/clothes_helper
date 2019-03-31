class City
  attr_reader :local_time, :temperature

  CITIES_OF_THE_WORLD = {
    1 => {
      city: 'New York, USA',
      timezone: 'America/New_York',
      xml: 'https://xml.meteoservice.ru/export/gismeteo/point/398.xml'
    },
    2 => {
      city: 'Toronto, Canada',
      timezone: 'America/Toronto',
      xml: 'https://xml.meteoservice.ru/export/gismeteo/point/419.xml'
    },
    3 => {
      city: 'Berlin, Germany',
      timezone: 'Europe/Berlin',
      xml: 'https://xml.meteoservice.ru/export/gismeteo/point/282.xml'
    },
    4 => {
      city: 'Paris, France',
      timezone: 'Europe/Paris',
      xml: 'https://xml.meteoservice.ru/export/gismeteo/point/247.xml'
    },
    5 => {
      city: 'Helsinki, Finland',
      timezone: 'Europe/Helsinki',
      xml: 'https://xml.meteoservice.ru/export/gismeteo/point/320.xml'
    },
    6 => {
      city: 'Sydney, Australia',
      timezone: 'Australia/Sydney',
      xml: 'https://xml.meteoservice.ru/export/gismeteo/point/408.xml'
    },
    7 => {
      city: 'Tokyo, Japan',
      timezone: 'Japan',
      xml: 'https://xml.meteoservice.ru/export/gismeteo/point/270.xml'
    }
  }.freeze

  private_constant :CITIES_OF_THE_WORLD

  def initialize(city_index)
    @index = city_index
    @local_time = TZInfo::Timezone.get(CITIES_OF_THE_WORLD[city_index][:timezone]).now
    @temperature = get_temperature(city_index)
  end

  def to_s
    city = City.city_name(CITIES_OF_THE_WORLD[@index][:city])
    I18n.t('city.result', city: city, local_time: @local_time, temperature: @temperature)
  end

  def self.get_number_of_cities
    CITIES_OF_THE_WORLD.size
  end

  def self.show_cities_list
    text_list = ''
    CITIES_OF_THE_WORLD.keys.each do |key|
      text_list += "#{key}: #{City.city_name(CITIES_OF_THE_WORLD[key][:city])}\n"
    end
    text_list
  end

  private

  # Метод, который из xml-документа считывает первый FORECAST узел
  # (первый прогноз) и высчитывает среднюю температуру
  def get_temperature(city_index)
    uri = URI.parse(CITIES_OF_THE_WORLD[city_index][:xml])
    response = Net::HTTP.get_response(uri)
    doc = REXML::Document.new(response.body)
    forecast_node = doc.root.get_elements('REPORT/TOWN/FORECAST')[0]
    min_temperature = forecast_node.elements[3].attributes['min'].to_i
    max_temperature = forecast_node.elements[3].attributes['max'].to_i
    ((max_temperature + min_temperature) / 2.0).round(2)
  end

  def self.city_name(city)
    case city
    when 'New York, USA' then I18n.t('city.collection')[0]
    when 'Toronto, Canada' then I18n.t('city.collection')[1]
    when 'Berlin, Germany' then I18n.t('city.collection')[2]
    when 'Paris, France' then I18n.t('city.collection')[3]
    when 'Helsinki, Finland' then I18n.t('city.collection')[4]
    when 'Sydney, Australia' then I18n.t('city.collection')[5]
    when 'Tokyo, Japan' then I18n.t('city.collection')[6]
    end
  end
end