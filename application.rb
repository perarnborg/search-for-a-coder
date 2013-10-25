#!/usr/bin/env ruby
#coding: utf-8

require "sinatra"
require "sinatra/partial"
require "sinatra/bundles"
require "rubygems"
require "data_mapper"
require "compass"
require "json"
require "sass"
require "curb"

# Setup custom app config, app helpers and setup routes - i.e. Start the show
set :app_file, __FILE__
set :root, File.dirname(__FILE__)

require "./config/config.rb"
require "./helpers.rb"
require "./routes.rb"
require "./settings.rb"

DataMapper.auto_upgrade!
