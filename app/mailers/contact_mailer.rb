class ContactMailer < ApplicationMailer
  default from: 'noreply@accounting-by-barbora.ch'
  
  def new_contact(contact)
    @contact = contact
    mail(
      to: 'admin@accounting-by-barbora.ch',
      subject: 'New Contact Form Submission'
    )
  end
end