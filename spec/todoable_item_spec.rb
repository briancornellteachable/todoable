require "spec_helper"

RSpec.describe Todoable::Item do
  describe "finish" do
    it "calls finish_item on the connection" do
      list = Todoable::List.new({"id" => 1})
      item = Todoable::Item.new(list, { "id" => 1, "name" => "item 1", "finished_at" => nil })
      expect(Todoable::List.connection).to receive(:finish_item).with(list.id, item.id)
      item.finish
    end
  end

  describe "delete" do
    it "calls delete_item on the connection" do
      list = Todoable::List.new({"id" => 2})
      item = Todoable::Item.new(list, { "id" => 2, "name" => "item 2", "finished_at" => nil })
      expect(Todoable::List.connection).to receive(:delete_item).with(list.id, item.id)
      item.delete
    end
  end

end
