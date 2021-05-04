require "test_helper"

class AccountTest < ActiveSupport::TestCase

  def setup
    @account = Account.new(
      name: "test1",
      password: "foo",
      password_confirmation: "foo"
    )
  end
end
