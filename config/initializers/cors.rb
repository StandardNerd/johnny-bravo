Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:4321', 'accounting-by-barbora.ch', 'www.accounting-by-barbora.ch'
    
    resource '/api/*',
      headers: :any,
      methods: [:get, :post, :options],
      credentials: false
  end
end