require 'i18n'
require 'rexml/document'
require 'net/http'
require 'tzinfo'
require_relative 'lib/city'
require_relative 'lib/program'
require_relative 'lib/repository'
require_relative 'lib/garment'
require_relative 'lib/wardrobe'

system('clear') || system('cls')

I18n.load_path << Dir[File.expand_path('config/locales') + '/*.yml']

if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

locales = I18n.available_locales

if !ARGV.empty? && locales.include?(ARGV[0].to_sym)
  I18n.locale = ARGV[0]
else
  puts("List of available locales:\n\n")
  I18n.available_locales.each_with_index { |e, i| puts("#{i + 1}: #{I18n.t("languages.#{e}")}") }

  print("\nEnter the locales code: ")
  code = STDIN.gets.to_i

  abort("\nFatal error! Wrong local code. The game went out in emergency mode.") if code <= 0 || code > locales.count

  I18n.locale = locales[code - 1]
end

xml_file_path = File.join(Dir.pwd, 'data', 'clothing.xml')

unless Dir.exist?(File.join(Dir.pwd, 'data'))
  abort(I18n.t('main.directory_error', working_directory: Dir.pwd))
end

unless File.exist?(xml_file_path)
  abort(I18n.t('main.directory_error', working_directory: Dir.pwd, file_path: File.basename(xml_file_path)))
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