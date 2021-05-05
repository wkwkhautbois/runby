require "faraday"
require "faraday_middleware"

class Execution < ApplicationRecord
  validates :program, presence: true, length: { maximum: 8000 }
  validates :input, length: { maximum: 1000 }
  before_save :execute_program

  enum result: { success: 0, failure: 1 }

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
    Faraday.new(url: "https://example.com") do |f|
      f.request :json
      f.response :json
    end
  end
end
