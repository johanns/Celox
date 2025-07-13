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
