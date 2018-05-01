require 'httparty'

module Todoable
  class Connection
    include HTTParty
    base_uri "http://todoable.teachable.tech/api"
    headers Accept: "application/json", "Content-Type" => "application/json"

    def lists
      response = authorized_request { |options| self.class.make_request("get", "/lists", options) }
      JSON.parse(response)["lists"]
    end

    def create_list(name)
      response = authorized_request do |options|
        options[:body] = { "list" => { "name" => name } }.to_json
        self.class.make_request("post", "/lists", options)
      end
      JSON.parse(response)
    end

    def list_info(id)
      response = authorized_request do |options|
        self.class.make_request("get", "/lists/#{id}", options)
      end
      JSON.parse(response)
    end

    def update_list(id, name)
      authorized_request do |options|
        options[:body] = { "list" => { "name" => name } }.to_json
        self.class.make_request("patch", "/lists/#{id}", options)
      end
    end

    def delete_list(id)
      authorized_request do |options|
        self.class.make_request("delete", "/lists/#{id}", options)
      end
    end

    def add_list_item(list_id, name)
      response = authorized_request do |options|
        options[:body] = { "item" => { "name" => name } }.to_json
        self.class.make_request("post", "/lists/#{list_id}/items", options)
      end
      JSON.parse(response)
    end

    def finish_item(list_id, item_id)
      authorized_request do |options|
        self.class.make_request("put", "/lists/#{list_id}/items/#{item_id}/finish", options)
      end
    end

    def delete_item(list_id, item_id)
      authorized_request do |options|
        self.class.make_request("delete", "/lists/#{list_id}/items/#{item_id}", options)
      end
    end

    def self.make_request(http_method, path, options)
      response = public_send(http_method, path, options)
      if response.code == 422
        raise UnprocessableEntityError.new(JSON.parse(response))
      elsif response.code == 404
        raise RecordNotFoundError.new
      else
        response
      end
    end

    private

    def authorized_request(options = {})
      @token ||= get_token
      set_auth_header(options)
      response = yield options
      if response.unauthorized?
        @token = get_token
        set_auth_header(options)
        response = yield options
        if response.unauthorized?
          raise UnauthorizedError.new
        end
      end
      response
    end

    def get_token
      auth = { username: user, password: password }
      self.class.post('/authenticate', basic_auth: auth)['token']
    end

    def set_auth_header(options)
      options[:headers] ||= {}
      options[:headers][:Authorization] = "Token token=\"#{@token}\""
    end

    def user
      ENV['TODOABLE_USER']
    end

    def password
      ENV['TODOABLE_PASSWORD']
    end
  end
end
