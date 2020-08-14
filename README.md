# Ganeshan

Ganeshan is a gem to find slow query with EXPAIN.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ganeshan'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ganeshan

## Usage

You can enable it with config/environments/development.rb
```rb
Ganeshan.enabled = true
```

Or You can use it without rails, but with active_record.

```rb
#!/usr/bin/env ruby

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  gem "ganeshan"
end


require 'active_record'
require 'ganeshan'

ActiveRecord::Base.establish_connection(
  host:     '127.0.0.1',
  adapter:  'postgresql',
  username: 'hoge',
  password: 'password',
  database: 'ganeshan'
)

Ganeshan.enabled = true

ActiveRecord::Schema.define do
  create_table :products, force: true do |t|
    t.text :name
  end
end

class Product < ActiveRecord::Base
end

p Product.all.to_a.count
p Product.all
p Product.limit(1)
p Product.where(id: 1).limit(10)
```

then, output is like this.

```rb
Ganeshan  INFO    2020-08-14 02:30:34 +0900       {
  "sql": "SELECT \"products\".* FROM \"products\"",
  "explain": [
    {
      "line": 1,
      "QUERY PLAN": "Seq Scan on products  (cost=0.00..22.00 rows=1200 width=40)"
    }
  ]
}
2

Ganeshan  INFO    2020-08-14 02:30:34 +0900       {
  "sql": "SELECT \"products\".* FROM \"products\" LIMIT $1",
  "explain": [
    {
      "line": 1,
      "QUERY PLAN": "Limit  (cost=0.00..0.20 rows=11 width=40)"
    },
    {
      "line": 2,
      "QUERY PLAN": "  ->  Seq Scan on products  (cost=0.00..22.00 rows=1200 width=40)"
    }
  ]
}
#<ActiveRecord::Relation [#<Product id: 2, name: "test2">, #<Product id: 1, name: "test1">]>

Ganeshan  INFO    2020-08-14 02:30:34 +0900       {
  "sql": "SELECT \"products\".* FROM \"products\" LIMIT $1",
  "explain": [
    {
      "line": 1,
      "QUERY PLAN": "Limit  (cost=0.00..0.02 rows=1 width=40)"
    },
    {
      "line": 2,
      "QUERY PLAN": "  ->  Seq Scan on products  (cost=0.00..22.00 rows=1200 width=40)"
    }
  ]
}
#<ActiveRecord::Relation [#<Product id: 2, name: "test2">]>

Ganeshan  INFO    2020-08-14 02:30:34 +0900       {
  "sql": "SELECT \"products\".* FROM \"products\" WHERE \"products\".\"id\" = $1 LIMIT $2",
  "explain": [
    {
      "line": 1,
      "QUERY PLAN": "Limit  (cost=0.15..8.17 rows=1 width=40)"
    },
    {
      "line": 2,
      "QUERY PLAN": "  ->  Index Scan using products_pkey on products  (cost=0.15..8.17 rows=1 width=40)"
    },
    {
      "line": 3,
      "QUERY PLAN": "        Index Cond: (id = '1'::bigint)"
    }
  ]
}
#<ActiveRecord::Relation [#<Product id: 1, name: "test1">]>

```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/geeknees/ganeshan. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/geeknees/ganeshan/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ganeshan project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/geeknees/ganeshan/blob/master/CODE_OF_CONDUCT.md).
