# Human Verification (Captcha) System

Celox implements a privacy-preserving, self-hosted human verification system to protect messages from being automatically accessed by bots and link previewers, which would trigger permanent message deletion.

## How It Works

1. **Initial Access**: When a user visits a message URL (`/m/:stub`), they are first presented with a simple math challenge.

2. **Challenge Generation**: The system generates a random addition problem (e.g., "What is 7 + 3?") and stores the correct answer in the session.

3. **Verification**: Users must enter the correct answer to proceed to the actual message.

4. **Access Control**: Only after successful verification is the message retrieved and deleted from the server.

## Security Benefits

- **Bot Protection**: Prevents automated crawlers and bots from accessing messages
- **Link Preview Protection**: Stops messaging platforms from pre-fetching message content
- **Privacy Preservation**: No third-party services or tracking scripts
- **Self-Hosted**: All challenge generation and verification happens on your server

## Implementation Details

### Controller Logic (Challengeable Concern)
- `generate_challenge`: Generates random math problems (addition/subtraction)
- `setup_challenge_session`: Creates challenge and stores answer in session with expiration
- `valid_challenge?`: Validates submitted answer against session and checks expiration
- `clear_challenge_session`: Cleans up session data after verification

### Session Management
- `session[:challenge_answer]`: Stores the correct numerical answer
- `session[:challenge_expires_at]`: Stores challenge expiration timestamp (5 minutes)

### Views and Frontend
- Challenge form is embedded in `show.html.erb` as part of the message display flow
- Uses Stimulus controller `message-decryption` for client-side interaction
- Sends challenge answer via `X-Challenge-Answer` HTTP header to `/m/:stub/fetch`
- Consistent styling with the main application design using Tailwind CSS and DaisyUI

### API Flow
1. User visits `/m/:stub` - triggers `show` action
2. `setup_challenge_session` creates math challenge and stores answer
3. User submits answer via JavaScript to `/m/:stub/fetch` endpoint
4. `fetch` action validates answer using `valid_challenge?`
5. On success, message is read and returned; session is cleared
6. On failure, error message is returned and user can retry

## Future Enhancements

### Potential Improvements
1. **Image-based Challenges**: Simple distorted text images (without external dependencies)
2. **Word Challenges**: "Type the word 'secure' to continue"
3. **Delay-based Verification**: "Wait 3 seconds, then click continue"
4. **Honeypot Fields**: Hidden form fields to catch basic bots
5. **Rate Limiting**: Prevent brute force attempts on challenges

### Advanced Options
1. **Progressive Difficulty**: Increase challenge complexity after failed attempts
2. **Time Limits**: Expire challenges after a certain time
3. **IP-based Tracking**: Remember verified IPs for a short period
4. **Device Fingerprinting**: Simple browser-based detection (still privacy-preserving)

## Testing

The system includes comprehensive RSpec tests covering:
- Challenge generation and storage
- Correct answer processing
- Incorrect answer handling
- Session management
- Access control flow

Run tests with:
```bash
bundle exec rspec spec/models/message_spec.rb
```

Note: Controller-specific tests for the challenge system may need to be added separately.

## Configuration

The captcha system can be easily modified by updating the `generate_challenge` method in the `Challengeable` concern. Current implementation uses simple addition, but can be extended to support various challenge types.

## Privacy Considerations

- No external services or scripts are used
- No user data is collected beyond the verification state
- Session data is automatically cleared after verification
- Challenges are generated server-side with secure randomization
- No persistent tracking or profiling
