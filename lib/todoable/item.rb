module Todoable
  class Item
    attr_accessor :list, :name, :id, :finished_at
    def initialize(list, options)
      @list = list
      @name = options["name"]
      @id = options["id"]
      @finished_at = options["finished_at"]
      @deleted = false
    end

    def finish
      connection.finish_item(list.id, id)
      true
    end

    def delete
      connection.delete_item(list.id, id)
      @deleted = true
    end

    private
    def connection
      List.connection
    end
  end
end
