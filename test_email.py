import smtplib
import os
from email.mime.text import MIMEText
from email.header import Header
from dotenv import load_dotenv


def send_plain_text_email(sender_email,  receiver_email, subject, body):

    load_dotenv()

    sender_password = os.getenv("EMAIL_PWD")

    print(f"pwd: {sender_password}")
    msg = MIMEText(body, 'plain', 'utf-8')
    msg['From'] = Header(f"Your Name <{sender_email}>", 'utf-8')
    msg['To'] = Header(f"Recipient Name <{receiver_email}>", 'utf-8')
    msg['Subject'] = Header(subject, 'utf-8')

    try:
        print("start send email")
        smtp_server = "smtp.office365.com" # Change this to your SMTP server
        smtp_port = 465 


        with smtplib.SMTP(smtp_server, smtp_port, timeout=10) as server:
            server.starttls(context=context)
            server.login(sender_email, sender_password)
            server.sendmail(sender_email, receiver_email, msg.as_string())
            print("Email sent successfully via Outlook SMTP!")

    except smtplib.SMTPAuthenticationError:
        print("Failed to send email: Authentication Error. Check your Outlook email address and App password.")
        print("If 2FA is on for your Microsoft account, you MUST use an 'App password'.")
    except smtplib.SMTPConnectError as e:
        print(f"Failed to connect to Outlook SMTP server (Connect Error): {e}. Check server address, port, and network.")
    except socket.timeout: # Catch the specific socket timeout error
        print("Connection to SMTP server timed out: The server did not respond within the given time.")
        print("This often indicates a network issue, firewall blocking, or incorrect server/port.")
    except OSError as e: # Catch broader OS-level errors which might include network issues
        print(f"An OS/network error occurred during connection: {e}.")
        print("This could be due to firewall, network blocking, or server unreachability.")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

if __name__ == "__main__":
    my_email = "rzhao@manispacecom.com"
    recipient_email = "rzhao@manispacecom.com"

    # Send a simple plain text email
    print("Attempting to send plain text email...")
    send_plain_text_email(
        sender_email=my_email,
        receiver_email=recipient_email,
        subject="Python Plain Text Email Test",
        body="Hello from Python! This is a test email sent using smtplib."
    )
    print("-" * 30)



