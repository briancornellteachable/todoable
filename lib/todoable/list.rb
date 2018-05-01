module Todoable
  class List
    attr_accessor :name, :id, :deleted

    def initialize(options)
      @name = options["name"]
      @id = options["id"]
      @deleted = false
    end

    def items
      response = self.class.connection.list_info(id)
      response["items"].map do |item|
        Item.new(self, item)
      end
    end

    def update_name(new_name)
      self.class.connection.update_list(id, new_name)
      self.name = new_name
    end

    def delete
      self.class.connection.delete_list(id)
      @deleted = true
    end

    def add_item(name)
      response = self.class.connection.add_list_item(id, name)
      Item.new(self, response)
    end

    class << self
      def all
        connection.lists.map {|list| new(list) }
      end

      def create(name)
        response = connection.create_list(name)
        new(response)
      end

      def connection
        @connection ||= Connection.new
      end
    end
  end
end
