# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create(email: 'john@doe.com', password: 'qwerty1234', username: 'jdoe', admin: true)
# user.categories.create([{name: 'Category 1', user: user}, {name: 'Category 2', user: user}])

# user.notes.create(content: 'private note', categories: user.categories)
# user.notes.create(content: 'public note', public: true, created_at: Time.now - 1.day)
# user.notes.create(content: "<script>alert('me');</script>", created_at: Time.now - 2.day)

# User.create(email: 'test@test.com', password: 'qwerty1234', username: 'test')
