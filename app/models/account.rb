class Account < ApplicationRecord
    has_many :account
    has_secure_password
end
