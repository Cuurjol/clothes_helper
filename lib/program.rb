class Program
  attr_reader :in_progress

  def initialize(repository, wardrobe)
    @in_progress = true
    @repository = repository
    @wardrobe = wardrobe
  end

  def show_menu_items
    cls
    puts("#{I18n.t('program.name')}\n\n")
    puts(I18n.t('program.menu'))
    puts(I18n.t('program.menu_items')[0])
    puts(I18n.t('program.menu_items')[1])
    puts(I18n.t('program.menu_items')[2])
    puts("#{I18n.t('program.menu_items')[3]}\n\n")
  end

  def input_menu_item
    print("#{I18n.t('program.input_item')} ")
    user_pick = gets.chomp
    pattern = /^[0-9]+$/
    until pattern.match?(user_pick) && user_pick.to_i > 0 && user_pick.to_i <= 4
      print("#{I18n.t('program.item_alert_message')} ")
      user_pick = gets.chomp
    end
    user_pick.to_i
  end

  def ask_question
    print("\n#{I18n.t('program.exit_question')} ")
    answer = gets.chomp.downcase
    until I18n.t('program.answers').include?(answer)
      print("#{I18n.t('program.exit_question_alert_message')} ")
      answer = gets.chomp.downcase
    end
    exit_program if I18n.t('program.correct_answers').include?(answer)
  end

  def what_to_wear
    cls
    puts(I18n.t('program.weather_question'))
    puts(City.show_cities_list)
    print("\n#{I18n.t('program.your_answer')} ")
    city_user_pick = gets.chomp

    until /^[0-9]+$/.match?(city_user_pick) &&  city_user_pick.to_i <= City.get_number_of_cities
      print("#{I18n.t('program.number_alert_message')} ")
      city_user_pick = gets.chomp
    end

    city_user_pick = city_user_pick.to_i
    city = City.new(city_user_pick)
    temperature = city.temperature
    finally_clothing = @wardrobe.what_to_wear(temperature)

    puts(city)
    if finally_clothing.empty?
      puts("\n#{I18n.t('program.no_clothes', temperature: temperature)}")
    else
      puts("\n#{I18n.t('program.clothes')}\n\n")
      finally_clothing.each { |garment| puts(garment) }
    end
  end

  def add_garment
    cls
    puts(I18n.t('program.garment_properties'))
    print("\n#{I18n.t('program.input_garment_name')} ")
    name = gets.chomp.capitalize

    print("#{I18n.t('program.input_garment_type')} ")
    type = gets.chomp.capitalize

    print("#{I18n.t('program.input_initial_temperature')} ")
    begin_number = gets.chomp

    print("#{I18n.t('program.input_final_temperature')} ")
    end_number = gets.chomp

    pattern = /^[0-9]+$|^-[0-9]+$/
    until pattern.match?(begin_number) && pattern.match?(end_number) && begin_number.to_i < end_number.to_i
      puts("\n#{I18n.t('program.alt_number_alert_message')}")
      print("#{I18n.t('program.re_input_initial_temperature')} ")
      begin_number = gets.chomp
      print("#{I18n.t('program.re_input_final_temperature')} ")
      end_number = gets.chomp
    end

    temperature_range = Range.new(begin_number.to_i, end_number.to_i)
    garment = Garment.new(name, type, temperature_range)
    @wardrobe.add(garment)
    puts("\n#{I18n.t('program.add_garment', garment: garment)}")
    update_file(by: :add, value: garment)
  end

  def delete_garment
    cls
    puts("#{I18n.t('program.clothes_list')}\n\n")
    puts(@wardrobe.to_s)
    print("\n#{I18n.t('program.input_garment_number')} ")
    garment_number = gets.chomp

    pattern = /^[0-9]+$/
    until pattern.match?(garment_number) && garment_number.to_i > 0 && garment_number.to_i <= @wardrobe.clothing.size
      print("#{I18n.t('program.number_alert_message')} ")
      garment_number = gets.chomp
    end

    garment = @wardrobe.search(by: :object, value: @wardrobe.clothing[garment_number.to_i - 1])
    @wardrobe.delete(garment)
    puts("\n#{I18n.t('program.delete_garment', garment: garment)}")
    update_file(by: :delete, value: garment)
  end

  def exit_program
    cls
    puts(I18n.t('program.exit_message'))
    @in_progress = false
  end

  private

  def cls
    system('cls') || system('clear')
  end

  def update_file(params)
    file_name = File.basename(@repository.file_path)
    puts("\n#{I18n.t('program.update_process', file_name: file_name)}")
    sleep(3)
    case params[:by]
    when :add
      @repository.add(params[:value])
    when :delete
      @repository.delete(params[:value])
    end
    puts(I18n.t('program.update_file', file_name: file_name, data_folder_path: @repository.data_folder_path))
  end
end