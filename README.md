# [Celox.ME](https://celox.me) :lock:

Celox.**ME**ssage is a secure, self-destructing messaging application built with Ruby on Rails 8. It features client-side encryption and automatic message expiration to maximize privacy.

Try the live app now at [https://celox.me](https://celox.me).

## :star2: Features

- **Client-Side Encryption**: Messages are encrypted in your browser before being sent, using AES-256-GCM encryption.
- **Self-Destructing Messages**: Messages are automatically deleted after being read once or upon expiration.
- **Flexible Expiration**: Choose from 5 minutes, 1 hour, 6 hours, or 1 day.
- **Zero-Knowledge Architecture**: The server never sees plaintext content.
- **Secure Key Management**: Encryption keys are generated client-side and transmitted only via URL fragments.
- **Responsive Design**: Built with Tailwind CSS and DaisyUI for a seamless experience on any device.

## :clipboard: Table of Contents

- [Features](#star2-features)
- [History](#hourglass-history)
- [Deployment](#rocket-deployment)
- [Architecture](#hammer_and_wrench-architecture)
- [Security Model](#lock-security-model)
- [Usage](#dart-usage)
- [Workflow Diagrams](#bar_chart-workflow-diagrams)
- [API Reference](#satellite-api-reference)
- [Technology Stack](#hammer_and_wrench-technology-stack)
- [Development](#rocket-development)
- [Testing](#test_tube-testing)
- [Configuration](#wrench-configuration)
- [Contributing](#handshake-contributing)
- [License](#page_facing_up-license)
- [Security](#shield-security)
- [Acknowledgments](#pray-acknowledgments)

## :hourglass: History

Celox.ME was originally started in 2011 as a personal project to learn Ruby on Rails and to build a secure, self-destructing message service that my team and I could fully trust. The motivation was twofold: to deepen my Rails expertise and to create a tool for sharing sensitive information via messengers and email—without leaving traces on those systems. Rather than relying on third-party solutions, I wanted an open-source alternative with a transparent codebase and security model. Over the years, Celox has evolved with modern Rails, security best practices, and a privacy-first architecture.

## :rocket: Deployment

Celox is designed for straightforward deployment on modern Ruby on Rails hosting platforms. It can be deployed using tools such as [Kamal](https://kamal-deploy.org/) or [Docker](https://www.docker.com/).

### Prerequisites

- **Ruby 3.4+**: Ensure you have the latest version of Ruby installed.
- **Docker**: Ensure you have the latest version of Docker installed.
- **SSH access** to your server.

### Before You Start

1. **Clone the repository** to your server or local machine:

    ```bash
    git clone https://github.com/johanns/celox.git
    cd celox
    ```

2. **Install dependencies**:

    ```bash
    bundle install
    npm install
    ```

3. **Generate the master key and credentials**:

    ```bash
    bin/setup-credentials
    ```

### Kamal Deployment

Please refer to the [Kamal documentation](https://kamal-deploy.org/) for an overview of the deployment process.

1. **Run the Kamal configuration setup generator**:

    ```bash
    bin/setup-kamal
    ```

2. **Prepare your server with Kamal**:

    ```bash
    kamal setup
    ```

3. **Deploy the application**:

    ```bash
    kamal deploy
    ```

### Docker Deployment

> **Caution:**
> Due to the sensitive nature of this application, it is strongly recommended to build the Docker image locally rather than pulling a prebuilt image from a third-party registry.

1. **Build the Docker image**:

    ```bash
    docker build -t celox:latest .
    ```

2. **Run the Docker container**:

    ```bash
    docker run -d -p 80:80 -p 443:443 --name celox -e TLS_DOMAIN=your-domain.com celox:latest
    ```

> **Note:** Replace `your-domain.com` with your actual domain name.

## :hammer_and_wrench: Architecture

Celox uses a zero-knowledge architecture with bot protection, ensuring the server never has access to plaintext message content:

**Privacy-preserving human verification** protects messages from bots and link previewers that would trigger permanent deletion when shared on messaging platforms.

1. **Client-Side Encryption**: All encryption and decryption happen in the browser.
2. **Fragment-Based Key Sharing**: Encryption keys are shared via URL fragments and never sent to the server.
3. **Human Verification**: Simple math captcha prevents automated access without third-party dependencies.
4. **Single-Read Destruction**: Messages are automatically deleted after their first successful access.
5. **Time-Based Expiration**: Expired messages are cleaned up automatically.

## :lock: Security Model

### Encryption Details

- **Algorithm**: AES-GCM (Galois/Counter Mode)
- **Key Derivation**: PBKDF2 with 1,000 iterations
- **Salt**: 16 random bytes per message
- **IV**: 12 random bytes per message
- **Key Length**: 256 bits

### Security Features

- **Zero-Knowledge**: The server never sees plaintext or encryption keys.
- **Forward Secrecy**: Each message uses unique encryption parameters.
- **Automatic Purging**: Messages are deleted from the database after being read.
- **Secure Random Generation**: Cryptographically secure random number generation (WebCrypto API).
- **Fragment-Based Key Sharing**: Encryption keys never leave the client.

## :dart: Usage

### Creating a Secure Message

1. Go to the home page.
2. Enter your confidential message (up to 5,000 characters).
3. Select an expiration time (from 5 minutes to 1 day).
4. Click "Encrypt & Create Link."
5. Share the generated secure link with your recipient.

### Reading a Secure Message

1. Click the secure link provided by the sender.
2. The message will automatically decrypt if the key is present in the URL.
3. The message is immediately deleted from the server after viewing.
4. One-time access only—subsequent visits will display an "already read" message.


## :bar_chart: Workflow Diagrams

### Message Creation Flow

```mermaid
sequenceDiagram
    participant User
    participant Browser
    participant Server
    participant Database

    User->>Browser: Enter message & expiration
    Browser->>Browser: Generate encryption key (client-side)
    Browser->>Browser: Encrypt message with AES-GCM
    Browser->>Server: POST encrypted payload
    Server->>Database: Store encrypted message + metadata
    Database-->>Server: Return message stub
    Server-->>Browser: Return stub + retrieval URL
    Browser->>Browser: Combine URL with encryption key fragment
    Browser-->>User: Display shareable secure link
```

### Message Retrieval Flow

```mermaid
sequenceDiagram
    participant Recipient
    participant Browser
    participant Server
    participant Database

    Recipient->>Browser: Click secure link with key fragment
    Browser->>Browser: Extract encryption key from URL fragment
    Browser->>Server: GET /m/:stub
    Server->>Database: Query message by stub
    alt Message exists and unread
        Database-->>Server: Return message metadata
        Server->>Server: Generate math captcha challenge
        Server-->>Browser: Return captcha form + session challenge
        Browser-->>Recipient: Display human verification form
        Recipient->>Browser: Solve math challenge
        Browser->>Server: POST /m/:stub/fetch with challenge answer
        Server->>Server: Validate challenge answer
        alt Challenge correct
            Server->>Database: Mark as read + retrieve encrypted content
            Database-->>Server: Return encrypted message + purge
            Server-->>Browser: Return encrypted payload
            Browser->>Browser: Decrypt message client-side
            Browser-->>Recipient: Display decrypted message
        else Challenge incorrect
            Server-->>Browser: Return challenge error
            Browser-->>Recipient: Show error + retry form
        end
    else Message already read
        Database-->>Server: Return read timestamp
        Server-->>Browser: Return "already read" response
        Browser-->>Recipient: Show "already read" message
    else Message expired/not found
        Server-->>Browser: 404 Not Found
        Browser-->>Recipient: Show error message
    end
```

Additional diagrams can be found in the [ADDITIONAL_DIAGRAMS.md](docs/ADDITIONAL_DIAGRAMS.md) file.

 ## :satellite: API Reference

See [API Reference](docs/API_REFERENCE.md) for detailed API documentation, including endpoints for creating, retrieving, and managing messages.

## :hammer_and_wrench: Technology Stack

### Backend

- **Ruby on Rails 8.0** – Web application framework
- **SQLite3** – Development database
- **PostgreSQL** – Production database (recommended)
- **Solid Queue** – Background job processing
- **Solid Cache** – Database-backed caching

### Frontend

- **Hotwire (Turbo + Stimulus)** – Modern SPA-like interactions
- **Tailwind CSS 4** – Utility-first CSS framework
- **DaisyUI 5** – UI component library
- **Web Crypto API** – Browser-native cryptography

### JavaScript Architecture

- **Stimulus Controllers** – Organized, reusable JavaScript components
- **Import Maps** – Native ES modules without bundling
- **Web Crypto API** – Secure client-side encryption

### Development Tools

- **ESLint** – JavaScript linting
- **Prettier** – Code formatting
- **RSpec** – Testing framework
- **FactoryBot** – Test data generation
- **Brakeman** – Security vulnerability scanning

## :rocket: Development

### Prerequisites

- Ruby 3.4+ (*recommend `chruby` and `ruby-install` for version management*)
- Rails 8.0+
- Node.js 18+ (for ESLint and Prettier)
- SQLite3 (development) or PostgreSQL (production)

### Setup (Local Development)

1. **Clone the repository**:

    ```bash
    git clone https://github.com/johanns/celox.git
    cd celox
    ```

2. **Install dependencies**:

    ```bash
    bundle install
    npm install
    ```

3. **Set up the database**:

    ```bash
    rails db:create
    rails db:migrate
    rails db:seed
    ```

4. **Start the development server**:

    ```bash
    bin/dev
    ```

5. **Open the application**:
    ```
    http://localhost:3000
    ```

## :test_tube: Testing

Run the test suite:

```bash
# Run all tests
bundle exec rspec

# Run specific test files
bundle exec rspec spec/models/message_spec.rb
bundle exec rspec spec/controllers/messages_controller_spec.rb

# Run with coverage
COVERAGE=true bundle exec rspec
```

## :wrench: Configuration

### Environment Variables

```bash
# Production settings
RAILS_ENV=production
SECRET_KEY_BASE=your_secret_key
```

### Deployment

The application is ready for deployment with:

- **Kamal** – Modern deployment tool
- **Docker** – Containerization

## :handshake: Contributing

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/amazing-feature`).
3. Commit your changes (`git commit -m 'feat: add amazing feature'`).
4. Push to your branch (`git push origin feature/amazing-feature`).
5. Open a Pull Request.

### Commit Convention

This project uses [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` – New features
- `fix:` – Bug fixes
- `docs:` – Documentation changes
- `style:` – Code style changes
- `refactor:` – Code refactoring
- `test:` – Test additions or changes
- `chore:` – Maintenance tasks

## :page_facing_up: License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## :shield: Security

### Reporting Security Issues

If you discover a security vulnerability, please email security@celox.me instead of creating a public issue.

### Security Best Practices

- Messages are encrypted on the client side before transmission.
- Encryption keys never leave the client browser.
- All inputs are validated and sanitized on the server side.
- Messages are automatically deleted after being read.
- Unread messages expire after a set period.
- CSRF protection is enabled.
- Secure headers are configured.

## :pray: Acknowledgments

- Built with [Ruby on Rails](https://rubyonrails.org/)
- UI powered by [Tailwind CSS](https://tailwindcss.com/) and [DaisyUI](https://daisyui.com/)
- Cryptography via [Web Crypto API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Crypto_API)
- Icons from [Heroicons](https://heroicons.com/)
- Contributions from the open-source community

---

Copyright © 2011-2025 Johanns Gregorian. All rights reserved.
