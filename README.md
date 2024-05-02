# JSON Parser in Ruby

This is a simple JSON parser implemented in Ruby. It provides a way to parse JSON strings into Ruby data structures.

## Usage

  ```ruby
  
  require_relative 'json_parser'
  
  parser = JSONParser.new
  parsed_data = parser.parse(json_string)
  ```

## Description

This JSON parser consists of a single class, `JSONParser`, which contains methods for parsing JSON strings. Here's a brief overview of each method:

-   `initialize`: Initializes the parser.
-   `parse`: Parses the JSON string passed as an argument.
-   `parse_tokens`: Parses the tokens extracted from the JSON string.
-   `parse_array`: Parses JSON arrays.
-   `parse_string`: Parses JSON strings.
-   `parse_object`: Parses JSON objects.
-   `concatenacao_strings_array`: Helper method to concatenate strings in arrays.
-   `tokenizar`: Tokenizes the input JSON string.

## Dependencies

This JSON parser depends on two additional files:

-   `pilha.rb`: Contains the implementation of a stack (`Pilha`) used internally by the parser.
-   `constantes.rb`: Contains constant definitions used in the parser.

Make sure to have these files in the same directory as the `JSONParser` file.

## Error Handling

The parser raises `ArgumentError` in case of syntax errors or unexpected tokens in the JSON string.

## Supported JSON Syntax

This parser supports basic JSON syntax including:

-   Objects (`{}`) and arrays (`[]`)
-   Strings, numbers, booleans, and null values
-   Nested objects and arrays
-   Escaped characters in strings

## Limitations

This JSON parser is designed for basic JSON parsing and may not handle all edge cases or complex JSON structures.

## Contributors
- Henrique Maques
- Gabriel Reimberg
- Murilo Oliveira
