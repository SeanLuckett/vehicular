# Vehicular

This project is a basic API for the vehicle listing domain.

[API documentation](https://documenter.getpostman.com/view/3168081/RW1YofVg)

# Domain model
![Relational diagram](/db/diagrams/vehicular_eerd.png?raw=true "Relational Diagram")

## Technical Trade-offs
* **Deep url structure:** (/make/models/:id instead of /make/models/?id=). This
is easier to navigate in a browser, but harder for some front-end libraries to
negotiate (i.e. React).
* **JsonApi ActiveModel serializer:** This allows for quicker response design because it
is a standard. However, it is far less customizable and makes it hard to get
wanted data (i.e. you can get a model's make id, but not it's name unless you 
use an includes. This, makes for a much larger payload with redundant data).
* **Lack of authentication/authorization:** I chose this so I could get more of
the basic API design done. However, there should at least be authorization around
the make, model, and option endpoints so you don't end up with the "Wayne Industries
"Batmobile 2000GTX" in the database (though that would be amazing).

## Dependencies
* Ruby 2.4.0+ (2.4.1 used)
* Rails 5.1.6
* Postgres 9.5.0.0

## Setting up
Once project is extracted or cloned, `cd vehicular` and:
1. `bundle install`
2. `rails db:create`
3. `rails db:migrate`
4. `rails s`

You'll have a server running on `localhost:3000`.

To run the tests, from application root type: `rspec`

## Future features
Following, are things to add:
* Authentication/Authorization
* Caching
* Rate limiting
* Logging
* SSL (should return error if not using https)
* JSON API relationship links for easier negotiation
* Endpoint queries for easier data retrieval (i.e. /makes/1/models/?name="Civic"&year="2010")
