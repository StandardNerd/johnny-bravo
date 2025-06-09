# app/controllers/api/v1/contacts_controller.rb
class Api::V1::ContactsController < ApplicationController
  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      # The form is valid and saved. Now send the email.
      # .deliver_later will send the email asynchronously using Active Job.
      ContactMailer.with(contact: @contact).contact_email.deliver_later

      render json: { status: 'Success', message: 'Message sent successfully' }, status: :created
    else
      # The form is invalid. Return the errors.
      render json: { status: 'Error', errors: @contact.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    # Use strong parameters to prevent mass assignment vulnerabilities.
    # Only allow the fields you expect.
    params.require(:contact).permit(:name, :email, :message, :nickname)
  end
end