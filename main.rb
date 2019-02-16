require 'rexml/document'
require 'net/http'
require 'tzinfo'
require_relative 'lib/city'
require_relative 'lib/program'
require_relative 'lib/repository'
require_relative 'lib/garment'
require_relative 'lib/wardrobe'

if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

xml_file_path = File.join(Dir.pwd, 'data', 'clothing.xml')

unless Dir.exist?(File.join(Dir.pwd, 'data'))
  abort("Папка data не существует в рабочей директории #{Dir.pwd}.")
end

unless File.exist?(xml_file_path)
  abort("В рабочей директории #{Dir.pwd} в папке data отсутствует файл #{File.basename(xml_file_path)}.")
end

repository = Repository.new(xml_file_path)
wardrobe = Wardrobe.new(repository.get_data)
program = Program.new(repository, wardrobe)

while program.in_progress
  program.show_menu_items
  user_pick = program.input_menu_item
  case user_pick
  when 1
    program.what_to_wear
    program.ask_question
  when 2
    program.add_garment
    program.ask_question
  when 3
    program.delete_garment
    program.ask_question
  when 4
    program.exit_program
  end
end