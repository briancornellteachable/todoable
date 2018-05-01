require 'spec_helper'

RSpec.describe Todoable::Connection do
  describe ".lists" do
    it "returns an array" do
      VCR.use_cassette("all_lists") do
        expect(Todoable::Connection.new.lists.class).to eq(Array)
      end
    end
  end

  describe ".create_list" do
    it "creates a list" do
      VCR.use_cassette("create_list") do
        name = "created list test"
        list = Todoable::Connection.new.create_list(name)
        expect(list["name"]).to eq name
      end
    end
  end

  describe ".list_info" do
    it "returns info about the list" do
      VCR.use_cassette("list_info") do
        name = "list info test"
        list = Todoable::Connection.new.create_list(name)
        id = list["id"]
        response = Todoable::Connection.new.list_info(id)
        expect(response["name"]).to eq(name)
        expect(response).to have_key("items")
      end
    end
  end

  describe ".update_list" do
    it "makes a patch request" do
      VCR.use_cassette("update_list") do
        expect(Todoable::Connection).to receive(:patch).and_call_original
        name = "update list test"
        list = Todoable::Connection.new.create_list(name)
        id = list["id"]
        updated_name = "updated_name"
        Todoable::Connection.new.update_list(id, updated_name)
      end
    end
  end

  describe ".delete_list" do
    it "makes a delete request" do
      VCR.use_cassette("delete_list") do
        expect(Todoable::Connection).to receive(:delete).and_call_original
        name = "delete list test"
        list = Todoable::Connection.new.create_list(name)
        id = list["id"]
        Todoable::Connection.new.delete_list(id)
      end
    end
  end

  describe ".add_list_item" do
    it "returns the item" do
      VCR.use_cassette("add_list_item") do
        list_name = "add item test"
        item_name = "added item"
        list = Todoable::Connection.new.create_list(list_name)
        id = list["id"]
        response = Todoable::Connection.new.add_list_item(id, item_name)
        expect response["name"] = item_name
      end
    end
  end

  describe ".finish_item" do
    it "makes a put request" do
      VCR.use_cassette("finish item") do
        expect(Todoable::Connection).to receive(:put).and_call_original
        list_name = "finish item test"
        item_name = "added item"
        list = Todoable::Connection.new.create_list(list_name)
        id = list["id"]
        response = Todoable::Connection.new.add_list_item(id, item_name)
        item_id = response["id"]
        Todoable::Connection.new.finish_item(id, item_id)
      end
    end
  end

  describe ".delete_item" do
    it "makes a delete request" do
      VCR.use_cassette("delete item") do
        expect(Todoable::Connection).to receive(:delete).and_call_original
        list_name = "delete item test"
        item_name = "added item"
        list = Todoable::Connection.new.create_list(list_name)
        id = list["id"]
        response = Todoable::Connection.new.add_list_item(id, item_name)
        item_id = response["id"]
        Todoable::Connection.new.delete_item(id, item_id)
      end
    end

  end

  describe "#make_request" do
    it "sends the supplied http_method to the class" do
      expect(Todoable::Connection).to receive(:get).and_return(double(code: 200))
      Todoable::Connection.make_request(:get, "", {})
    end
  end

  describe "#headers" do
    it "includes Accept: application/json" do
      expect(Todoable::Connection.headers[:Accept]).to eq "application/json"
    end

    it "includes Content-Type: application/json" do
      expect(Todoable::Connection.headers["Content-Type"]).to eq "application/json"
    end
  end

  describe "authorized_request" do
    it "raises an unauthorized error for invalid users" do
      VCR.use_cassette("unauthorized user") do
        connection = Todoable::Connection.new
        allow(connection).to receive(:password).and_return "fake"
        expect { connection.lists }.to raise_error Todoable::UnauthorizedError
      end
    end
  end
end

