json.array!(@plans) do |plan|
  json.extract! plan, :id, :id, :stripe_id, :name, :created_at, :updated_at
  json.url plan_url(plan, format: :json)
end
