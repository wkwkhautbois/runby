# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

2.times do |no|
  Account.create(name: "test#{no}", password: "test")
end

Execution.skip_callback(:save, :before, :execute_program)
5.times do |no|
  account = Account.find_by(name: "test#{no % 2}")
  Execution.create(
    account_id: account.id,
    program: "puts my name is\"#{account.name}\"",
    input: "this is input",
    output: "this is output",
    result: 0
  )
end