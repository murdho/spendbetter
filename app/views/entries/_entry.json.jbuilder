json.extract! entry, :id, :date, :amount, :currency, :party, :message, :external_id, :folder_id, :created_at, :updated_at
json.url entry_url(entry, format: :json)
