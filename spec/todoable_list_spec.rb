require "spec_helper"

RSpec.describe Todoable::List do
  describe ".connection" do
    it "it is a Todoable::Connection" do
      expect(Todoable::List.connection).to be_a Todoable::Connection
    end
  end

  describe ".all" do
   it "calls lists on the connection" do
     expect(Todoable::List.connection).to receive(:lists).and_return []
     Todoable::List.all
   end

   it "returns Todoable lists" do
     list_array = [{"name" => "list one", "id" => 1}]
     allow(Todoable::List.connection).to receive(:lists).and_return list_array
     expect(Todoable::List.all.first).to be_a Todoable::List
   end
  end

  describe ".create" do
    it "calls create_list on the connection" do
      expect(Todoable::List.connection).to receive(:create_list).with("new list")
        .and_return({})
      Todoable::List.create("new list")
    end

    it "returns a Todoable list" do
      list = {"name" => "list two", "id" => 1}
      allow(Todoable::List.connection).to receive(:create_list).and_return list
      expect(Todoable::List.create("list two")).to be_a Todoable::List
    end
  end

  describe "#update_name" do
    it "calls update_list on the connection" do
      list = Todoable::List.new("name" => "list three", "id" => 1)
      expect(Todoable::List.connection).to receive(:update_list).with(list.id, "new name")
      list.update_name("new name")
    end
  end

  describe "#delete" do
    it "calls delete_list on the connection" do
      list = Todoable::List.new("name" => "list four", "id" => 2)
      expect(Todoable::List.connection).to receive(:delete_list).with(list.id)
      list.delete
    end
  end

  describe "#add_item" do
    it "calls add_list_item on the connection" do
      item_name = "item 1"
      item_hash = {}
      list = Todoable::List.new("name" => "list five", "id" => 3)
      expect(Todoable::List.connection).to receive(:add_list_item).with(list.id, item_name)
        .and_return(item_hash)
      list.add_item(item_name)
    end

    it "returns a Todoable item" do
      item_name = "item 2"
      item_hash = { "name" => item_name, "finished_at" => nil, "id" => 1 }
      list = Todoable::List.new("name" => "list six", "id" => 4)
      allow(Todoable::List.connection).to receive(:add_list_item).with(list.id, item_name)
        .and_return(item_hash)
      item = list.add_item(item_name)
      expect(item).to be_a Todoable::Item
      expect(item.list).to eq list
    end
  end

  describe "#items" do
    it "calls list_info on the connection" do
      list = Todoable::List.new("name" => "list seven", "id" => 5)
      items_hash = { "items" => [] }
      expect(Todoable::List.connection).to receive(:list_info).with(list.id)
        .and_return(items_hash)
      list.items
    end

    it "returns Todoable items" do
      list = Todoable::List.new(name: "list eight", id: 6)
      items_hash = { "items" => [{ "name" => "item 3", "id" => 2, "finished_at" => nil }] }
      allow(Todoable::List.connection).to receive(:list_info).with(list.id)
        .and_return(items_hash)
      items = list.items
      expect(items.first).to be_a Todoable::Item
      expect(items.first.name).to eq "item 3"
    end
  end
end
