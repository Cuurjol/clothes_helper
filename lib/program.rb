class Program
  attr_reader :in_progress

  def initialize(repository, wardrobe)
    @in_progress = true
    @repository = repository
    @wardrobe = wardrobe
  end

  def show_menu_items
    cls
    puts("Программа \"Гардероб\".\n\n")
    puts('Меню программы:')
    puts('1: Что надеть?')
    puts('2: Добавить новую вещь в гардероб')
    puts('3: Убрать нужную вещь из гардероба')
    puts("4. Выйти из программы\n\n")
  end

  def input_menu_item
    print('Введите пункт меню программ: ')
    user_pick = gets.chomp
    pattern = /^[0-9]+$/
    until pattern.match?(user_pick) && user_pick.to_i > 0 && user_pick.to_i <= 4
      print('Некорректный ввод числа. Повторите ввод: ')
      user_pick = gets.chomp
    end
    user_pick.to_i
  end

  def ask_question
    print("\nВы хотите выйти из программ?(1:да/0:нет) ")
    answer = gets.chomp.downcase
    until %w[да нет 1 0].include?(answer)
      print('Некорректный ввод ответа на вопрос. Повторите ввод: ')
      answer = gets.chomp.downcase
    end
    exit_program if %w[да 1].include?(answer)
  end

  def what_to_wear
    cls
    puts('Погоду для какого города Вы хотите узнать?')
    puts(City.show_cities_list)
    print("\nВаш вариант ответ: ")
    city_user_pick = gets.chomp

    until /^[0-9]+$/.match?(city_user_pick) &&  city_user_pick.to_i <= City.get_number_of_cities
      print('Некорректный ввод числа. Повторите ввод: ')
      city_user_pick = gets.chomp
    end

    city_user_pick = city_user_pick.to_i
    city = City.new(city_user_pick)
    temperature = city.temperature
    finally_clothing = @wardrobe.what_to_wear(temperature)

    puts(city)
    if finally_clothing.empty?
      puts("\nНет подходящей одежды для погоды с температоруй #{temperature}. " +
               'Сидите дома и не выходите на улицу!')
    else
      puts("\nПредлагаем сегодня надеть:\n\n")
      finally_clothing.each { |garment| puts(garment) }
    end
  end

  def add_garment
    cls
    puts('У вещи есть три свойства: Название, Тип и Диапазон Температур.')
    print("\nВведите Название: ")
    name = gets.chomp.capitalize

    print('Введите Тип: ')
    type = gets.chomp.capitalize

    print('Введите начальное значение температуры: ')
    begin_number = gets.chomp

    print('Введите конечное значение температуры: ')
    end_number = gets.chomp

    pattern = /^[0-9]+$|^-[0-9]+$/
    until pattern.match?(begin_number) && pattern.match?(end_number) && begin_number.to_i < end_number.to_i
      puts("\nНекорректный ввод чисел.")
      print('Повторно введите начальное значение температуры: ')
      begin_number = gets.chomp
      print('Повторно введите конечное значение температуры: ')
      end_number = gets.chomp
    end

    temperature_range = Range.new(begin_number.to_i, end_number.to_i)
    garment = Garment.new(name, type, temperature_range)
    @wardrobe.add(garment)
    puts("\nНовая вещь была добавлена в гардероб:\n#{garment}")
    update_file(by: :add, value: garment)
  end

  def delete_garment
    cls
    puts("Список вещей в гардеробе:\n\n")
    puts(@wardrobe.to_s)
    print("\nВведите номер вещи, которую вы хотите удалить: ")
    garment_number = gets.chomp

    pattern = /^[0-9]+$/
    until pattern.match?(garment_number) && garment_number.to_i > 0 && garment_number.to_i <= @wardrobe.clothing.size
      print('Некорректный ввод числа. Повторите ввод: ')
      garment_number = gets.chomp
    end

    garment = @wardrobe.search(by: :object, value: @wardrobe.clothing[garment_number.to_i - 1])
    @wardrobe.delete(garment)
    puts("\nВещь была убрана из гардероба: #{garment}")
    update_file(by: :delete, value: garment)
  end

  def exit_program
    cls
    puts('Вы вышли из программы.')
    @in_progress = false
  end

  private

  def cls
    system('cls') || system('clear')
  end

  def update_file(params)
    file_name = File.basename(@repository.file_path)
    puts("\nИдёт процесс обновления #{file_name} файла...")
    sleep(3)
    case params[:by]
    when :add
      @repository.add(params[:value])
    when :delete
      @repository.delete(params[:value])
    end
    puts("Файл #{file_name} успешно обновлён в директории #{@repository.data_folder_path}")
  end
end