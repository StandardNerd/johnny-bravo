require "test_helper"

class ContactMailerTest < ActionMailer::TestCase
  test "new_contact sends email with contact details" do
    contact = Contact.new(
      name: "Test User",
      email: "test@example.com",
      phone: "1234567890",
      preferred_call_time: "morning",
      message: "This is a test message. It is long enough."
    )

    email = ContactMailer.new_contact(contact)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['admin@accounting-by-barbora.ch'], email.to
    assert_equal ['noreply@accounting-by-barbora.ch'], email.from
    assert_equal "New Contact Form Submission", email.subject

    # Check for content in HTML part
    assert_match contact.name, email.html_part.body.encoded
    assert_match contact.email, email.html_part.body.encoded
    assert_match contact.phone, email.html_part.body.encoded
    assert_match contact.preferred_call_time, email.html_part.body.encoded
    assert_match contact.message, email.html_part.body.encoded

    # Check for content in text part
    assert_match contact.name, email.text_part.body.encoded
    assert_match contact.email, email.text_part.body.encoded
    assert_match contact.phone, email.text_part.body.encoded
    assert_match contact.preferred_call_time, email.text_part.body.encoded
    assert_match contact.message, email.text_part.body.encoded
  end

  test "new_contact is enqueued" do
    contact = Contact.new(
      name: "Test User",
      email: "test@example.com",
      phone: "1234567890",
      preferred_call_time: "morning",
      message: "This is a test message. It is long enough."
    )

    assert_enqueued_jobs 1 do
      ContactMailer.new_contact(contact).deliver_later
    end
  end
end
