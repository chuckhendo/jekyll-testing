require 'rubygems'
require 'bundler'

Bundler.require
require "rack/jekyll"

run Rack::Jekyll.new(:auto => true)