# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

(FinePrint::Contract.create do |contract|
   contract.name    = 'general_terms_of_use'
   contract.content = 'Placeholder for general terms of use, required for new installations to function'
   contract.title   = 'Terms of Use'
 end).publish

(FinePrint::Contract.create do |contract|
   contract.name    = 'privacy_policy'
   contract.content = 'Placeholder for privacy policy, required for new installations to function'
   contract.title   = 'Privacy Policy'
 end).publish