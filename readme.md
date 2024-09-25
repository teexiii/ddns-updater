# window-ddns-updater

window-ddns-updater is a Windows batch script designed to automatically update DNS records when your IP address changes. It's particularly useful for maintaining accurate DNS records for systems with dynamic IP addresses.

## Features

- Periodically checks for IP address changes
- Updates Cloudflare DNS records when the IP address changes
- Configurable through environment variables

## Prerequisites

- Windows operating system
- cURL installed and available in the system PATH
- Cloudflare account with API access

## Setup

1. Clone this repository or download the script file.
2. Create a `.env` file in the same directory as the script with the following content:

   ```
   IP_URL=http://your-ip-check-url
   CF_API_URL=https://api.cloudflare.com/client/v4/zones/your-zone-id/dns_records/your-record-id
   DOMAIN=your-domain.com
   CF_EMAIL=your-cloudflare-email@example.com
   CF_API_KEY=your-cloudflare-api-key
   ```

   Replace the placeholders with your actual values.

3. Ensure that the `.env` file is in the same directory as the script.

## Usage

Run the script by double-clicking it or executing it from the command line:

```
.\window-ddns-updater.bat
```

The script will run continuously, checking for IP changes every 30 seconds and updating the DNS record when necessary.

## Security Note

Keep your `.env` file secure, as it contains sensitive information. Do not share it or commit it to public repositories.
