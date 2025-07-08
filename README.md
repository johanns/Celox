# Celox 🔐

A secure, self-destructing message application built with Ruby on Rails 8, featuring client-side encryption and automatic message expiration.

## 🌟 Features

- **Client-Side Encryption**: Messages are encrypted in the browser before transmission using AES-GCM encryption
- **Self-Destructing Messages**: Messages automatically delete after being read once or when they expire
- **Flexible Expiration**: Choose from 5 minutes, 1 hour, 6 hours, or 1 day
- **Zero-Knowledge Architecture**: Server never sees plaintext content
- **Secure Key Management**: Encryption keys are generated client-side and transmitted via URL fragments
- **Real-Time Feedback**: Modern UI with loading states and encryption animations
- **Responsive Design**: Built with Tailwind CSS and DaisyUI for all devices

## 📋 Table of Contents

- [Features](#-features)
- [Architecture](#-architecture)
- [Security Model](#-security-model)
- [Installation](#-installation)
- [Usage](#-usage)
- [API Reference](#-api-reference)
- [Workflow Diagrams](#-workflow-diagrams)
- [Technology Stack](#-technology-stack)
- [Contributing](#-contributing)
- [License](#-license)

## 🏗️ Architecture

Celox follows a zero-knowledge architecture where the server never has access to plaintext message content:

1. **Client-Side Encryption**: All encryption/decryption happens in the browser
2. **Fragment-Based Key Sharing**: Encryption keys are shared via URL fragments (never sent to server)
3. **Single-Read Destruction**: Messages are automatically purged after first access
4. **Time-Based Expiration**: Automatic cleanup of expired messages

## 🔒 Security Model

### Encryption Details

- **Algorithm**: AES-256-GCM (Galois/Counter Mode)
- **Key Derivation**: PBKDF2 with 1000 iterations
- **Salt**: 16 random bytes per message
- **IV**: 12 random bytes per message
- **Key Length**: 256 bits

### Security Features

- **Zero-Knowledge**: Server never sees plaintext or encryption keys
- **Forward Secrecy**: Each message uses unique encryption parameters
- **Automatic Purging**: Messages are deleted from database after reading
- **Secure Random Generation**: Cryptographically secure random number generation (WebCrypto API)
- **Fragment-Based Key Sharing**: Encryption keys never leave the client

## 🚀 Installation

### Prerequisites

- Ruby 3.4+
- Rails 8.0+
- Node.js 18+
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

3. **Setup database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the development server**
   ```bash
   bin/dev
   ```

5. **Visit the application**
   ```
   http://localhost:3000
   ```

## 🎯 Usage

### Creating a Secure Message

1. Navigate to the home page
2. Enter your confidential message (max 5,000 characters)
3. Select an expiration time (5 minutes to 1 day)
4. Click "Encrypt & Create Link"
5. Share the generated secure link with the recipient

### Reading a Secure Message

1. Click on the secure link provided by the sender
2. The message will automatically decrypt if the key is present in the URL
3. The message is immediately purged from the server after viewing
4. One-time access only - subsequent visits will show "already read" message

## 📡 API Reference

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
- If unread: Returns encrypted message view with client-side decryption
- If already read: Returns "already read" notification
- If expired/not found: Returns 404 error

### Expiration Options

- `five_minutes`: 5 minutes
- `one_hour`: 1 hour (default)
- `six_hours`: 6 hours
- `one_day`: 1 day

## 📊 Workflow Diagrams

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
        Database-->>Server: Return encrypted message
        Server->>Database: Mark as read + purge content
        Server-->>Browser: Return encrypted payload
        Browser->>Browser: Decrypt message client-side
        Browser-->>Recipient: Display decrypted message
    else Message already read
        Database-->>Server: Return read timestamp
        Server-->>Browser: Return "already read" response
        Browser-->>Recipient: Show "already read" message
    else Message expired/not found
        Server-->>Browser: 404 Not Found
        Browser-->>Recipient: Show error message
    end
```

### Security Architecture

```mermaid
graph TB
    A[User Input] --> B[Client-Side Encryption]
    B --> C[Generate Random Key]
    B --> D[Generate Salt & IV]
    B --> E[AES-GCM Encryption]

    E --> F[Encrypted Payload]
    C --> G[URL Fragment]

    F --> H[Server Storage]
    G --> I[Shareable Link]

    H --> J[(Database)]
    J --> K[Encrypted Data Only]

    I --> L[Recipient]
    L --> M[Extract Key from Fragment]
    M --> N[Client-Side Decryption]

    style B fill:#e1f5fe
    style E fill:#e8f5e8
    style K fill:#fff3e0
    style N fill:#e8f5e8
```

### Data Flow Architecture

```mermaid
graph LR
    subgraph "Client Side"
        A[User Message] --> B[JavaScript Crypto]
        B --> C[AES-GCM Encryption]
        C --> D[Encrypted Payload]

        E[URL Fragment] --> F[Encryption Key]
        F --> G[Client Decryption]
    end

    subgraph "Server Side"
        D --> H[Rails Controller]
        H --> I[Message Model]
        I --> J[(SQLite/PostgreSQL)]

        J --> K[Encrypted Storage]
        K --> L[Auto-Expiration]
        K --> M[Read-Once Deletion]
    end

    subgraph "Security Boundary"
        N[Zero Knowledge]
        O[No Plaintext on Server]
        P[Fragment-Based Key Sharing]
    end

    style A fill:#e3f2fd
    style C fill:#e8f5e8
    style G fill:#e8f5e8
    style J fill:#fff3e0
    style N fill:#ffebee
```

### Message Lifecycle

```mermaid
stateDiagram-v2
    [*] --> Created: User creates message
    Created --> Encrypted: Client-side encryption
    Encrypted --> Stored: Server stores encrypted data
    Stored --> Shared: Secure link generated
    Shared --> Accessed: Recipient clicks link
    Accessed --> Decrypted: Client-side decryption
    Decrypted --> Purged: Message deleted from server
    Purged --> [*]: Lifecycle complete

    Stored --> Expired: Time limit reached
    Expired --> AutoPurged: Cleanup job runs
    AutoPurged --> [*]: Lifecycle complete

    note right of Encrypted: AES-GCM with unique key
    note right of Stored: Only encrypted data on server
    note right of Purged: Zero traces remain
```

## 🛠️ Technology Stack

### Backend
- **Ruby on Rails 8.0** - Web application framework
- **SQLite3** - Development database
- **PostgreSQL** - Production database (recommended)
- **Solid Queue** - Background job processing
- **Solid Cache** - Database-backed caching

### Frontend
- **Hotwire (Turbo + Stimulus)** - Modern SPA-like interactions
- **Tailwind CSS 4** - Utility-first CSS framework
- **DaisyUI 5** - UI component library
- **Web Crypto API** - Browser-native cryptography

### JavaScript Architecture
- **Stimulus Controllers** - Organized, reusable JavaScript components
- **Import Maps** - Native ES modules without bundling
- **Web Crypto API** - Secure client-side encryption

### Development Tools
- **ESLint** - JavaScript linting
- **Prettier** - Code formatting
- **RSpec** - Testing framework
- **FactoryBot** - Test data generation
- **Brakeman** - Security vulnerability scanning

## 🧪 Testing

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

## 🔧 Configuration

### Environment Variables

```bash
# Production settings
RAILS_ENV=production
SECRET_KEY_BASE=your_secret_key

# Database
DATABASE_URL=postgresql://user:pass@localhost/celox_production

# Optional: Custom expiration cleanup
MESSAGE_CLEANUP_INTERVAL=5.minutes
```

### Deployment

The application is configured for deployment with:

- **Kamal** - Modern deployment tool
- **Docker** - Containerization
- **Thruster** - HTTP asset caching and compression

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Commit Convention

This project uses [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `style:` - Code style changes
- `refactor:` - Code refactoring
- `test:` - Test additions or changes
- `chore:` - Maintenance tasks

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🛡️ Security

### Reporting Security Issues

If you discover a security vulnerability, please send an email to security@celox.app instead of creating a public issue.

### Security Best Practices

- Messages are encrypted client-side before transmission
- Encryption keys never leave the client browser
- Server-side validation and sanitization of all inputs
- Automatic purging of messages after reading
- Time-based expiration for unread messages
- CSRF protection enabled
- Secure headers configured

## 🙏 Acknowledgments

- Built with [Ruby on Rails](https://rubyonrails.org/)
- UI powered by [Tailwind CSS](https://tailwindcss.com/) and [DaisyUI](https://daisyui.com/)
- Cryptography via [Web Crypto API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Crypto_API)
- Icons from [Heroicons](https://heroicons.com/)

---

**Celox** - Secure, self-destructing messages made simple. 🔐✨
