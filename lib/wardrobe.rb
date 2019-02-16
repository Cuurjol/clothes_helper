class Wardrobe
  attr_reader :clothing

  def initialize(clothing = [])
    @clothing = clothing
  end

  # Метод, который подбирает одежду по погоде
  def what_to_wear(temperature)
    finally_clothing = []
    clothing_type.each do |garment_type|
      clothing = search_all(by: :type, value: garment_type)
      suitable_clothing = clothing.select { |garment| garment.suitable_for_weather?(temperature) }
      finally_clothing.push(suitable_clothing.sample) unless suitable_clothing.empty?
    end
    finally_clothing
  end

  # Метод, который добавляет вещь в гардероб
  def add(garment_object)
    @clothing.push(garment_object)
  end

  # Метод, который убирает вещь из гардероб
  def delete(garment_object)
    @clothing.delete(garment_object)
  end

  # Метод, который возвращает первый попавшийся объект класса Garment.
  # Этот метод принимает на вход ассоциативный массив, в котором могут
  # быть два ключа: :by и :value. Ниже приведены примеры вызова метода search:
  #
  # wardrobe.search(by: :name, value: "Шлепанцы")
  # wardrobe.search(by: :type, value: "Обувь")
  # wardrobe.search(by: :temperature_range, value: Range.new(-10, 20))
  # wardrobe.search(by: :object, value: garment)
  def search(params)
    case params[:by]
    when :name
      @clothing.find { |garment| garment.name == params[:value] }
    when :type
      @clothing.find { |garment| garment.type == params[:value] }
    when :temperature_range
      @clothing.find { |garment| garment.temperature_range == params[:value] }
    when :object
      @clothing.find { |garment| garment == params[:value] }
    end
  end

  # Метод, который возвращает массив объектов класса Garment.
  # Этот метод принимает на вход ассоциативный массив, в котором могут
  # быть два ключа: :by и :value. Ниже приведены примеры вызова метода search:
  #
  # wardrobe.search_all(by: :type, value: "Обувь")
  # wardrobe.search_all(by: :temperature_range, value: Range.new(-10, 20))
  def search_all(params)
    case params[:by]
    when :type
      @clothing.find_all { |garment| garment.type == params[:value] }
    when :temperature_range
      @clothing.find_all { |garment| garment.temperature_range == params[:value] }
    end
  end

  def to_s
    lines = ''
    @clothing.each_with_index do |garment, index|
      lines += "#{index + 1}: #{garment}\n"
    end
    lines
  end

  private

  # Метод, который возврашает массив типов вещей
  def clothing_type
    @clothing.map(&:type).uniq
  end
end
