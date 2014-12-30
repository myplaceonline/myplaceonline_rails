# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

order = Category.create(name: "order",link: "order", position: 0)
joy = Category.create(name: "joy", link: "joy", position: 1)
meaning = Category.create(name: "meaning", link: "meaning", position: 2)
passwords = Category.create(name: "passwords", link: "passwords", position: 0, parent: order)
movies = Category.create(name: "movies", link: "movies", position: 0, parent: joy)
wisdoms = Category.create(name: "wisdoms", link: "wisdoms", position: 0, parent: meaning)
to_dos = Category.create(name: "to_dos", link: "to_dos", position: 0, parent: order)
