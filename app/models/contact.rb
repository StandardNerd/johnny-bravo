# app/models/contact.rb
class Contact < ApplicationRecord
  # --- Validations ---
  validates :name, presence: true
  validates :message, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # This is our honeypot field. It should be blank.
  # If it's filled in, a bot likely submitted the form.
  validates :nickname, absence: true
end