# app/mailers/contact_mailer.rb
class ContactMailer < ApplicationMailer
  # Use the email from the form as the 'from' address for context,
  # but set a 'reply_to' so you can reply directly to the user.
  default from: 'notifications@your-app-domain.com'

  def contact_email
    @contact = params[:contact]
    
    # Use Rails credentials to store the recipient email securely.
    mail(
      to: Rails.application.credentials.contact_form_recipient!,
      subject: "New Contact Form Submission from #{@contact.name}",
      reply_to: @contact.email
    )
  end
end