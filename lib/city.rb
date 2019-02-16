class City
  attr_reader :local_time, :temperature

  CITIES_OF_THE_WORLD = {
    1 => {
      city: 'Нью-Йорк, США',
      timezone: 'America/New_York',
      xml: 'https://xml.meteoservice.ru/export/gismeteo/point/398.xml'
    },
    2 => {
      city: 'Торонто, Канада',
      timezone: 'America/Toronto',
      xml: 'https://xml.meteoservice.ru/export/gismeteo/point/419.xml'
    },
    3 => {
      city: 'Берлин, Германия',
      timezone: 'Europe/Berlin',
      xml: 'https://xml.meteoservice.ru/export/gismeteo/point/282.xml'
    },
    4 => {
      city: 'Париж, Франция',
      timezone: 'Europe/Paris',
      xml: 'https://xml.meteoservice.ru/export/gismeteo/point/247.xml'
    },
    5 => {
      city: 'Хельсинки, Финляндия',
      timezone: 'Europe/Helsinki',
      xml: 'https://xml.meteoservice.ru/export/gismeteo/point/320.xml'
    },
    6 => {
      city: 'Сидней, Австралия',
      timezone: 'Australia/Sydney',
      xml: 'https://xml.meteoservice.ru/export/gismeteo/point/408.xml'
    },
    7 => {
      city: 'Токио, Япония',
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
    city = CITIES_OF_THE_WORLD[@index][:city]
    "#{city} — местное время #{@local_time}, температура #{@temperature}°C"
  end

  def self.get_number_of_cities
    CITIES_OF_THE_WORLD.size
  end

  def self.show_cities_list
    text_list = ''
    CITIES_OF_THE_WORLD.keys.each do |key|
      text_list += "#{key}: #{CITIES_OF_THE_WORLD[key][:city]}\n"
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
end