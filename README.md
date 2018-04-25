# Vehicular

This project is a basic API for the vehicle listing domain.

## Domain model
![alt text](https://github.com/SeanLuckett/vehicular/db/diagrams/vehicular_eerd.png "Relational Diagram")

[API Documentation](https://documenter.getpostman.com/view/3168081/RW1YofVg)

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
Following, are things to consider:
