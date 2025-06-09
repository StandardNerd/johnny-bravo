# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # In development, you might allow all origins.
    # For production, you MUST restrict this to your frontend's domain.
    origins 'http://localhost:3001', 'https://accounting-by-barbora.ch', 'https://www.accounting-by-barbora.ch'

    resource '/api/v1/contacts',
      headers: :any,
      methods: [:post, :options]
  end
end