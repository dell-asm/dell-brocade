source 'https://rubygems.org'

group :development, :test do
  gem 'rake'
  gem 'rspec'
  gem 'puppetlabs_spec_helper'
  if puppetversion = ENV['PUPPET_GEM_VERSION']
    gem 'puppet', puppetversion
  else
    gem 'puppet', '3.4.2'
  end
end