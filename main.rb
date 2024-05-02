require_relative 'jsonParse'

teste_json = '{
  "user": {
    "id": 12345,
    "username": "johndoe",
    "money": 175.10,
    "email": "john.doe@example.com",
    "is_active": true,
    "registration_date": "2024-04-23T14:30:00Z",
  },
  "posts": [
    {
      "id": 1,
      "title": "First Post",
      "content": "This is the content of the first post.",
      "tags": ["technology", "programming"],
      "views": 1024,
    },
    {
      "id": 2,
      "title": "Second Post",
      "content": "Another post with some content.",
      "tags": ["lifestyle", "travel"],
      "views": 512,
    }
  ],
  "settings": {
    "theme": "dark",
    "notifications": false,
    "preferences": {
      "language": null,
      "timezone": "America/New_York",
    },
  },
  "metadata": {
    "created_at": "2024-04-23T15:00:00Z",
    "last_updated": "2024-04-23T16:45:00Z",
  },
}'

parser = JSONParser.new
resultado = parser.parse(teste_json)
puts resultado