class Contact < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true, format: { 
    with: /\A[\+]?[\d\s\-\(\)\.]{10,15}\z/, 
    message: "must be a valid phone number" 
  }
  validates :preferred_call_time, presence: true, inclusion: { 
    in: ['morning', 'afternoon', 'evening', 'anytime'],
    message: "must be morning, afternoon, evening, or anytime"
  }
  validates :message, presence: true, length: { minimum: 10, maximum: 1000 }
  
  # Clean phone number before saving
  before_save :format_phone_number
  
  # Optional: Add spam detection
  before_create :check_for_spam
  
  # Scope for filtering by call time preference
  scope :prefers_morning, -> { where(preferred_call_time: 'morning') }
  scope :prefers_afternoon, -> { where(preferred_call_time: 'afternoon') }
  scope :prefers_evening, -> { where(preferred_call_time: 'evening') }
  scope :prefers_anytime, -> { where(preferred_call_time: 'anytime') }
  
  private
  
  def format_phone_number
    # Remove all non-digits except + at the beginning
    self.phone = phone.gsub(/[^\d\+]/, '') if phone.present?
  end
  
  def check_for_spam
    # Simple spam detection - you can make this more sophisticated
    spam_keywords = ['viagra', 'casino', 'lottery', 'winner']
    content = "#{name} #{email} #{message}".downcase
    
    if spam_keywords.any? { |keyword| content.include?(keyword) }
      self.spam = true
    end
  end
end