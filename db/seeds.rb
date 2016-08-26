# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
CreatePlan.call(stripe_plan_id: 'saasbase_starter', name: 'SaaSBase Starter', amount: 2999, interval: 'month', currency: 'usd', trial_period_days: 7)
CreatePlan.call(stripe_plan_id: 'saasbase_business', name: 'SaaSBase Business', amount: 4999, interval: 'month', currency: 'usd', trial_period_days: 7)
CreatePlan.call(stripe_plan_id: 'saasbase_enterprise', name: 'SaaSBase Enterprise', amount: 9999, interval: 'month', currency: 'usd', trial_period_days: 7)