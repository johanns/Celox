# Recurring Jobs with SolidQueue

This application uses SolidQueue for background job processing, including recurring jobs for maintenance tasks.

## Cleanup Expired Messages Job

The `CleanupExpiredMessagesJob` automatically removes expired messages from the database.

### Configuration

The job is configured in `config/recurring.yml`:

```yaml
development:
  cleanup_expired_messages:
    class: CleanupExpiredMessagesJob
    queue: default
    schedule: every 15 minutes

production:
  cleanup_expired_messages:
    class: CleanupExpiredMessagesJob
    queue: default
    schedule: every 5 minutes
```

### Schedule Options

SolidQueue supports various schedule formats:

- `every 5 minutes`
- `every hour`
- `every day`
- `at 3am every day`
- `at 2:30pm on weekdays`
- `every monday at 9am`

### Running the Job System

#### Development

To start all services including the job worker with recurring jobs:

```bash
bin/dev
```

Or start the job worker separately:

```bash
bin/rails solid_queue:start
```

#### Production

In production, you'll want to run the SolidQueue worker as a separate service:

```bash
bundle exec rails solid_queue:start
```

### Manual Execution

You can manually trigger the cleanup job in several ways:

#### Using the Job Class

```bash
bin/rails runner "CleanupExpiredMessagesJob.perform_now"
```

#### Using the Rake Task

```bash
bin/rails cleanup_expired_messages
```

#### In Rails Console

```ruby
CleanupExpiredMessagesJob.perform_now
```

### Monitoring

You can monitor job execution in the Rails logs. The cleanup job logs:
- When it starts
- How many messages were deleted
- When it completes

### Testing

The job includes comprehensive tests in `spec/jobs/cleanup_expired_messages_job_spec.rb`.

Run the tests with:

```bash
bundle exec rspec spec/jobs/cleanup_expired_messages_job_spec.rb
```
