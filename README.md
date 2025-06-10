# johnny-bravo

# Contact Form API

This is a Ruby on Rails API application designed to handle contact form submissions. It saves the submitted data to a SQLite3 database and forwards it as an email to a designated recipient.

## Features

- **POST `/api/v1/contacts`**: Endpoint to receive contact form submissions.
- **Database Storage**: All valid submissions are saved in a `contacts` table.
- **Asynchronous Emailing**: Emails are sent in the background using Active Job to ensure fast API responses.
- **Spam Protection**: Includes a basic "honeypot" field to deter simple bots.
- **Secure Credentials**: Uses Rails encrypted credentials to store sensitive data.

---

## Setup and Installation

1.  **Clone the repository:**

    ```bash
    git clone <your-repository-url>
    cd contact_form_api
    ```

2.  **Install dependencies:**

    ```bash
    bundle install
    ```

3.  **Create and migrate the database:**

    ```bash
    rails db:migrate
    ```

4.  **Configure Recipient Email:**
    This application requires you to set the email address where contact form notifications will be sent. This is stored securely in the Rails credentials.

    ```bash
    # This will open a secure editor (e.g., vim, nano, or VS Code)
    EDITOR=vim rails credentials:edit
    ```

    Add the following key to the file, then save and close it:

    ```yaml
    contact_form_recipient: "your-email-address@example.com"
    ```

5.  **Start the Rails server:**
    ```bash
    rails s
    ```
    The API will now be running at `http://localhost:3000`.

---

## Email Configuration

This application can be configured to send emails using different methods for development and production environments.

### Development Environment

In development, we use the `letter_opener_web` gem to intercept emails and display them in the browser. This prevents sending real emails during testing.

After submitting a form successfully, you can view the sent email by navigating to:
**[http://localhost:3000/letter_opener](http://localhost:3000/letter_opener)**

### Production Environment (Using msmtp)

For production, this guide details how to configure email sending via `msmtp`, a lightweight and powerful SMTP client. This is a great alternative to adding more gems to the application and is ideal for Linux-based deployments.

#### Step 1: Install msmtp on the Server

Use your server's package manager to install `msmtp`.

- **For Debian/Ubuntu:**
  ```bash
  sudo apt-get update && sudo apt-get install -y msmtp msmtp-mta
  ```
- **For CentOS/RHEL/Fedora:**
  ```bash
  sudo yum install msmtp
  # or
  sudo dnf install msmtp
  ```

#### Step 2: Configure msmtp Credentials

Create a configuration file in the home directory of the user that runs the Rails application (e.g., `/home/deploy/.msmtprc`).

```bash
touch ~/.msmtprc

```

Add your SMTP provider's details to this file. Below is an example using a Gmail App Password.
⚠️ Gmail Security Note: If you use Gmail with 2-Factor Authentication (2FA), you must generate a 16-character App Password from your Google Account settings. Do not use your regular account password.
File: ~/.msmtprc

```bash
# Default settings for all accounts
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        ~/.msmtp.log

# Your email provider account (e.g., Gmail)
account        default
host           smtp.gmail.com
port           587
from           your-account@gmail.com
user           your-account@gmail.com
password       your-16-character-app-password

```

#### Step 3: Secure the Configuration File

The ~/.msmtprc file contains a plain-text password and must have its permissions restricted. msmtp will refuse to run if the file is not secure.
`chmod 600 ~/.msmtprc`

#### Step 4: Test msmtp from the Command Line

Verify that your msmtp setup works independently of Rails.

```bash
printf "To: test-recipient@example.com\nFrom: your-account@gmail.com\nSubject: msmtp test\n\nThis is a test email." | msmtp -t
```

Check the recipient's inbox. If the email arrives, msmtp is configured correctly. If not, check the log for errors: cat ~/.msmtp.log.

#### Step 5: Configure Action Mailer in Rails

Finally, configure Rails to use msmtp for sending mail in the production environment.

1. Find the path to the msmtp executable:

`which msmtp`

Example output: `/usr/bin/msmtp`

2. Edit config/environments/production.rb and add the following configuration:

```ruby
# config/environments/production.rb

# Use the :sendmail delivery method to pipe mail to msmtp
config.action_mailer.delivery_method = :sendmail
config.action_mailer.perform_deliveries = true

# Point Rails to the msmtp executable
config.action_mailer.sendmail_settings = {
  location: '/usr/bin/msmtp', # Use the path from the 'which' command
  arguments: '-t'
}
```

Your production environment is now configured to send emails through msmtp. Remember to set up a robust background job processor like Sidekiq or GoodJob to handle the deliver_later calls efficiently.

### API Endpoint Usage

`POST /api/v1/contacts`

Submits the contact form.

Request Body:

```json
{
  "contact": {
    "name": "Jane Doe",
    "email": "jane.doe@example.com",
    "message": "I would like to inquire about your services.",
    "nickname": ""
  }
}
```

The nickname field is a "honeypot" for spam. It should be hidden on your frontend and must be submitted as a blank string.

Success Response (201 Created):

```json
{
  "status": "Success",
  "message": "Message sent successfully"
}
```
