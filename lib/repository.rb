class Repository
  attr_reader :file_path, :data_folder_path

  def initialize(file_path)
    file = File.new(file_path, 'r:UTF-8')
    @document_xml = REXML::Document.new(file) # Кэш xml-документа текстового файла 'clothing.xml'
    file.close

    @file_path = file_path
    @data_folder_path = File.absolute_path(File.dirname(@file_path))
    @data_hash = {}
    @counter = 0

    unless @document_xml.root.nil?
      @document_xml.root.elements.each do |garment_node|
        name = garment_node.elements[1].text
        type = garment_node.elements[2].text
        temp_range_text = garment_node.elements[3].text
        temperature_range = Range.new(left_limit_range(temp_range_text), right_limit_range(temp_range_text))
        garment = Garment.new(name, type, temperature_range)
        id = garment_node.attributes['id'].to_i
        @data_hash[id] = garment

        # Проверка нужна для того, чтобы в хэш-таблице не происходило перетирание
        # старых данных на новые данные при выполнении операции добавления!
        #
        # P.S. Если вдруг кто-то решил вручную редактировать xml-файл
        @counter = id if @counter < id
      end
    end
  end

  def add(garment)
    information = create_information_array(garment)

    # Если существует xml-файл, но в нём нет корневого узла xml-структуры!
    if @document_xml.root.nil?
      @document_xml = REXML::Document.new('<?xml version="1.0" encoding="utf-8"?>')
      @document_xml.add_element('clothing')
    end

    create_garment_node(information)
    @data_hash[@counter] = garment
    rewrite_xml_file
  end

  def delete(garment)
    id = @data_hash.key(garment)
    if @data_hash.delete(id)
      @document_xml.root.elements.delete("garment[@id=#{id}]")
      rewrite_xml_file
    end
  end

  def get_data
    @data_hash.values
  end

  private

  def left_limit_range(line)
    line.scan(/-?\d+|\+?\d+/).map(&:to_i).sort.min
  end

  def right_limit_range(line)
    line.scan(/-?\d+|\+?\d+/).map(&:to_i).sort.max
  end

  def create_information_array(garment)
    left_number = garment.temperature_range.begin
    right_number = garment.temperature_range.end

    begin_number = left_number > 0 ? "+#{left_number}" : left_number.to_s
    end_number = right_number > 0 ? "+#{right_number}" : right_number.to_s

    [garment.name, garment.type, "(#{begin_number}, #{end_number})"]
  end

  def create_garment_node(information)
    @counter += 1

    garment_node = @document_xml.root.add_element('garment')
    garment_node.add_attribute('id', @counter.to_s)

    name_node = garment_node.elements.add('name')
    name_node.text = information[0]

    type_node = garment_node.elements.add('type')
    type_node.text = information[1]

    temperature_node = garment_node.elements.add('temperature')
    temperature_node.text = information[2]
  end

  def rewrite_xml_file
    file = File.new(@file_path, 'w:UTF-8')
    formatter = REXML::Formatters::Pretty.new
    formatter.compact = true
    formatter.write(@document_xml, file)
    file.close
  end
end