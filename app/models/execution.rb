require "faraday"
require "faraday_middleware"

class Execution < ApplicationRecord
  belongs_to :account
  validates :program, presence: true, length: { maximum: 8000 }
  validates :input, length: { maximum: 1000 }
  before_save :execute_program

  enum result: { success: 0, failure: 1 }

  EXECUTION_API_URL_BASE = (ENV["EXECUTION_API_URL_BASE"] || "http://localhost:8080").freeze
  EXECUTION_API_TOKEN = (ENV["EXECUTION_API_TOKEN"] || "abcde").freeze

  private

  def execute_program
    api_result = connection.post "/execution", {
      program: self.program,
      input: self.input,
    }
    self.result = api_result.body["result"]
    self.output = api_result.body["output"]
  end

  def connection
    Faraday.new(url: EXECUTION_API_URL_BASE, headers: {"X-API-TOKEN" => EXECUTION_API_TOKEN}) do |f|
      f.request :json
      f.response :json
      f.response :raise_error
      f.response :logger
    end
  end
end
