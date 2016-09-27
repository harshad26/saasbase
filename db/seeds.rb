# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
d1 = DateTime.now

Branding.delete_all
Branding.create!([{
                   name: "LocatorApp",
                   address_line_1: "line 1",
                   address_line_2: "line 2",
                   city: "Richmond",
                   country: "Canada",
                   postal_code: "V6Y1J5",
                   created_at: d1,
                   updated_at: d1
               }])

Plan.delete_all
Plan.create!([{
                  stripe_plan_id: "small_business",
                  name: "Small Business",
                  created_at: d1,
                  updated_at: d1
              }])
Plan.create!([{
                  stripe_plan_id: "office",
                  name: "Office",
                  created_at: d1,
                  updated_at: d1
              }])
Plan.create!([{
                  stripe_plan_id: "enterprise",
                  name: "Enterprise",
                  created_at: d1,
                  updated_at: d1
              }])