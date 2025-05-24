class Api::V1::ContactsController < ApplicationController
  # Rate limiting (optional - requires rack-attack gem)
  # throttle('contact_form', limit: 5, period: 1.hour) do |req|
  #   req.ip if req.path == '/api/v1/contacts' && req.post?
  # end
  
  def create
    @contact = Contact.new(contact_params)
    
    if @contact.save
      # Send email notification (optional)
      ContactMailer.new_contact(@contact).deliver_later
      
      render json: { 
        status: 'success', 
        message: 'Thank you for your message. We\'ll get back to you soon!' 
      }, status: :created
    else
      render json: { 
        status: 'error', 
        message: 'Please fix the following errors:', 
        errors: @contact.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end
  
  # Optional: Admin endpoint to list contacts
  def index
    @contacts = Contact.where(spam: false).order(created_at: :desc)
    render json: @contacts
  end
  
  private
  
  def contact_params
    params.require(:contact).permit(:name, :email, :phone, :preferred_call_time, :message)
  end
end