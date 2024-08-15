# JWT Authentication App

## Requirements

- Ruby version 3.1.2
- Sinatra
- PostgreSQL 

## Installation

1. Clone the repository: [`git clone https://github.com/SunSof/auth_sevice.git`]
2. Install dependencies: `bundle install`
3. Setup database: `bundle exec rake db:create` `bundle exec rake db:migrate`

## Running

Start the server: `ruby app.rb`
Start the sidekiq: `bundle exec sidekiq -r ./app.rb`

## Testing

Run tests with RSpec: `rspec spec`
