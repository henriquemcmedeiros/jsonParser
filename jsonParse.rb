require_relative 'pilha'
require_relative 'constantes'

class JSONParser
  def initialize
    @pilha = Pilha.new
  end

  def parse(jsonString)
    tokens = tokenizar(jsonString)
    parsed = parse_tokens(tokens)

    parsed[0]
  end

  private

  def parse_tokens(tokens)
    token = tokens.first

    raise ArgumentError, 'A raiz deve ser um objeto' if @pilha.vazia? && token != JSON_ABRE_CHAVES

    case token
    when JSON_ASPAS
      @pilha.empilhar(JSON_ASPAS)
      parse_string(tokens.drop(1))
    when JSON_ABRE_COLCHETES
      @pilha.empilhar(JSON_FECHA_COLCHETES)
      parse_array(tokens.drop(1))
    when JSON_ABRE_CHAVES
      @pilha.empilhar(JSON_FECHA_CHAVES)
      parse_object(tokens.drop(1))
    else
      [token, tokens.drop(1)]
    end
  end

  def parse_array(tokens)
    json_array = []

    token = tokens.first

    if token == JSON_FECHA_COLCHETES && @pilha.topo == JSON_FECHA_COLCHETES
      @pilha.desempilhar
      return json_array, tokens.drop(1)
    end

    loop do
      json, tokens = parse_tokens(tokens)
      json_array << json

      token = tokens.first
      if token == JSON_FECHA_COLCHETES && @pilha.topo == JSON_FECHA_COLCHETES
        @pilha.desempilhar
        return json_array, tokens.drop(1)
      end
      raise ArgumentError, "Esperava uma vírgula após o objeto no array, mas obteve #{token}" unless token == JSON_VIRGULA

      tokens = tokens.drop(1)
    end

    raise ArgumentError, 'Esperava o fechamento do colchete do array'
  end

  def parse_string(tokens)
    json_string = ''

    token = tokens.first

    if token == JSON_ASPAS && @pilha.topo == JSON_ASPAS
      @pilha.desempilhar
      return json_string, tokens.drop(1)
    end

    loop do
      json, tokens = parse_tokens(tokens)
      json_string << json

      token = tokens.first
      if token == JSON_ASPAS && @pilha.topo == JSON_ASPAS
        @pilha.desempilhar
        return json_string, tokens.drop(1)
      end
      raise ArgumentError, 'Esperava uma aspas para fechar o elemento' unless token == JSON_ASPAS

      tokens = tokens.drop(1)
    end
  end

  def parse_object(tokens)
    json_object = {}

    token = tokens.first
    if token == JSON_FECHA_CHAVES && @pilha.topo == JSON_FECHA_CHAVES
      @pilha.desempilhar
      return json_object, tokens.drop(1)
    end

    loop do
      if token == JSON_VIRGULA && @pilha.topo == JSON_FECHA_CHAVES && tokens[0] == JSON_FECHA_CHAVES
        tokens = tokens.drop(1)
        @pilha.desempilhar
        return json_object, tokens
      end

      raise ArgumentError, 'Esperava para abrir a string chave' unless tokens.first == JSON_ASPAS
      tokens = tokens.drop(1)

      json_key = tokens.first
      raise ArgumentError, "Esperava uma chave de string, mas obteve: #{json_key}" unless json_key.is_a?(String)
      tokens = tokens.drop(1)

      raise ArgumentError, 'Esperava uma aspas para fechar o elemento' unless tokens.first == JSON_ASPAS
      tokens = tokens.drop(1)

      unless tokens.first == JSON_DOIS_PONTOS
        raise ArgumentError, "Esperava dois pontos após a chave no objeto, mas obteve: #{token}"
      end

      json_value, tokens = parse_tokens(tokens.drop(1))
      json_object[json_key] = json_value

      token = tokens.first
      if token == JSON_FECHA_CHAVES && @pilha.topo == JSON_FECHA_CHAVES
        @pilha.desempilhar
        return json_object, tokens.drop(1)
      end

      raise ArgumentError, "Esperava uma vírgula após o par no objeto, mas obteve: #{token}" unless token == JSON_VIRGULA
      tokens = tokens.drop(1)
    end
    raise ArgumentError, 'Esperava o fechamento da chave do objeto'
  end

  def concatenacao_strings_array(array)
    retorno = []
    i = 0

    while i < array.length
      if array[i].is_a?(String) && array[i] == '"'
        tokenString = ""
        retorno << array[i]
        i += 1
        while array[i] != '"' && i < array.length
          tokenString += array[i].to_s + " "
          i += 1
        end
        tokenString = tokenString.strip
        retorno << tokenString
      end
      retorno << array[i]
      i += 1
    end

    retorno
  end

  def tokenizar(jsonString)
    matches = jsonString.scan(/[:{}\"\[\]]|[^\"^ |^\n|^,]+|\d+\.\d+|\d+|,/).flatten.compact

    parsed_values = matches.map do |value|
      case value
      when /\A\d+\z/ 
        value.to_i
      when /\A\d+\.\d+\z/
        value.to_f
      when 'true', 'false'
        value == 'true'
      when 'null'
        nil
      else
        value
      end
    end

    parsed_values = concatenacao_strings_array(parsed_values)

    parsed_values
  end
end