# [Celox.ME](https://celox.me) :lock:

Celox.**ME**ssage is a secure, self-destructing message application built with Ruby on Rails 8. It features client-side encryption and automatic message expiration for maximum privacy.

Try the live app now at [https://celox.me](https://celox.me)

## :star2: Features

- **Client-Side Encryption**: Messages are encrypted in your browser before being sent, using AES-256-GCM encryption.
- **Self-Destructing Messages**: Messages are automatically deleted after being read once or when they expire.
- **Flexible Expiration**: Choose from 5 minutes, 1 hour, 6 hours, or 1 day.
- **Zero-Knowledge Architecture**: The server never sees plaintext content.
- **Secure Key Management**: Encryption keys are generated client-side and transmitted only via URL fragments.
- **Responsive Design**: Built with Tailwind CSS and DaisyUI for a seamless experience on any device.

## :clipboard: Table of Contents

- [Features](#star2-features)
- [History](#hourglass-history)
- [Architecture](#hammer_and_wrench-architecture)
- [Security Model](#lock-security-model)
- [Installation](#rocket-installation)
- [Usage](#dart-usage)
- [API Reference](#satellite-api-reference)
- [Workflow Diagrams](#bar_chart-workflow-diagrams)
- [Technology Stack](#hammer_and_wrench-technology-stack)
- [Testing](#test_tube-testing)
- [Configuration](#wrench-configuration)
- [Contributing](#handshake-contributing)
- [License](#page_facing_up-license)
- [Security](#shield-security)
- [Acknowledgments](#pray-acknowledgments)

## :hourglass: History

Celox.ME was originally started in 2011 as a personal project to learn Ruby on Rails and to build a secure, self-destructing message service that my team and I could fully trust. The motivation was twofold: to deepen my Rails expertise, and to create a tool for sharing sensitive information via messengers and email -- without leaving traces on those systems. Rather than relying on third-party solutions, I wanted an open-source alternative with a transparent codebase and security model. Over the years, Celox has evolved with modern Rails, security best practices, and a privacy-first architecture.

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

## :rocket: Installation

### Prerequisites

- Ruby 3.4+
- Rails 8.0+
- Node.js 18+ (for ESLint and Prettier)
- SQLite3 (development) or PostgreSQL (production)

### Setup

1. **Clone the repository**

    ```bash
    git clone https://github.com/your-username/celox.git
    cd celox
    ```

2. **Install dependencies**

    ```bash
    bundle install
    npm install
    ```

3. **Set up the database**

    ```bash
    rails db:create
    rails db:migrate
    rails db:seed
    ```

4. **Start the development server**

    ```bash
    bin/dev
    ```

5. **Open the application**
    ```
    http://localhost:3000
    ```

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

## :satellite: API Reference

### Create Message

```http
POST /m
Content-Type: application/json

{
  "message": {
    "body": "Your confidential message",
    "expiration_duration": "one_hour"
  }
}
```

**Response:**

```json
{
    "success": true,
    "message": {
        "stub": "abc123xyz",
        "retrieval_url": "https://app.com/m/abc123xyz"
    }
}
```

### Retrieve Message

```http
GET /m/:stub
```

**Response:**

- If unread: Returns the captcha challenge form for human verification.
- If already read: Returns an "already read" notification.
- If expired or not found: Returns a 404 error.

### Fetch Message (After Captcha)

```http
GET /m/:stub/fetch
Headers:
  X-Challenge-Answer: 42
```

**Response (Success):**

```json
{
    "success": true,
    "body": "encrypted_message_data",
    "read_at": "2024-01-01T12:00:00Z"
}
```

**Response (Challenge Failed):**

```json
{
    "success": false,
    "error": "Invalid challenge. Please refresh and try again."
}
```

### Expiration Options

- `five_minutes`: 5 minutes
- `one_hour`: 1 hour (default)
- `six_hours`: 6 hours
- `one_day`: 1 day

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

### Security & Data Flow Architecture

```mermaid
graph TB
    subgraph "� Message Creation Flow"
        A[👤 User Input] --> B[🔍 Input Validation]
        B --> C[🔧 WebCrypto API]
        C --> D[🔒 AES-GCM Encryption]
        D --> E[📦 Encrypted Payload]
        C --> F[🔑 Encryption Key]
        F --> G[🔗 URL Fragment]
    end

    subgraph "� Transport Security"
        E --> H[🛡️ HTTPS/TLS 1.3]
        H --> I[🔐 CSRF Protection]
        I --> J[📋 Content Security Policy]
    end

    subgraph "⚡ Server Processing"
        J --> K[🚀 Rails Controller]
        K --> L[🛡️ Strong Parameters]
        L --> M[🧹 Input Sanitization]
        M --> N[📋 Message Model]
        N --> O[(💾 Database Storage)]
        O --> P[🔐 Encrypted Data Only]
    end

    subgraph "📨 Message Retrieval Flow"
        G --> Q[🌐 Recipient Browser]
        Q --> R[🔍 Extract Key from URL]
        R --> S[🧠 Human Verification]
        S --> T[🔢 Math Captcha]
        T --> U[📥 Fetch Encrypted Message]
        O --> U
        U --> V[🔓 Client-Side Decryption]
        V --> W[📄 Plaintext Message]
    end

    subgraph "🛡️ Security Features"
        X[⏰ Auto-Expiration]
        Y[🗑️ Read-Once Deletion]
        Z[🤐 Zero Knowledge Server]
        AA[🔗 Fragment-Based Keys]
    end

    O -.-> X
    O -.-> Y
    K -.-> Z
    G -.-> AA

    style A fill:#ff6b6b,color:#fff
    style B fill:#4ecdc4,color:#fff
    style C fill:#45b7d1,color:#fff
    style D fill:#96ceb4,color:#fff
    style E fill:#feca57,color:#000
    style F fill:#ff9ff3,color:#000
    style G fill:#54a0ff,color:#fff
    style H fill:#5f27cd,color:#fff
    style I fill:#ff6348,color:#fff
    style J fill:#2ed573,color:#fff
    style K fill:#3742fa,color:#fff
    style L fill:#ff3838,color:#fff
    style M fill:#ff9f43,color:#fff
    style N fill:#10ac84,color:#fff
    style O fill:#ee5a52,color:#fff
    style P fill:#0abde3,color:#fff
    style Q fill:#feca57,color:#000
    style R fill:#ff6b6b,color:#fff
    style S fill:#ff9ff3,color:#000
    style T fill:#4ecdc4,color:#fff
    style U fill:#45b7d1,color:#fff
    style V fill:#96ceb4,color:#fff
    style W fill:#54a0ff,color:#fff
    style X fill:#5f27cd,color:#fff
    style Y fill:#ff6348,color:#fff
    style Z fill:#2ed573,color:#fff
    style AA fill:#3742fa,color:#fff
```

### Message Lifecycle

```mermaid
stateDiagram-v2
    [*] --> Created: User creates message
    Created --> Encrypted: Client-side encryption
    Encrypted --> Stored: Server stores encrypted data
    Stored --> Shared: Secure link generated
    Shared --> Accessed: Recipient clicks link
    Accessed --> Challenge: Human verification required
    Challenge --> Verified: Math captcha solved
    Verified --> Decrypted: Client-side decryption
    Decrypted --> Purged: Message deleted from server
    Purged --> [*]: Lifecycle complete

    Challenge --> Failed: Incorrect answer
    Failed --> Challenge: Retry verification

    Stored --> Expired: Time limit reached
    Expired --> AutoPurged: Cleanup job runs
    AutoPurged --> [*]: Lifecycle complete

    note right of Encrypted: AES-GCM with unique key
    note right of Stored: Only encrypted data on server
    note right of Challenge: Bot protection via math captcha
    note right of Purged: Zero traces remain
```

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

- Messages are encrypted client-side before transmission.
- Encryption keys never leave the client browser.
- All inputs are validated and sanitized server-side.
- Messages are automatically deleted after being read.
- Unread messages expire after a set time.
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
