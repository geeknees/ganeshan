#!/usr/bin/env ruby

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  gem "ganeshan", path:'../'
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
