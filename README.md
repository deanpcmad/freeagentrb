# FreeAgentRB

**This library is a work in progress**

FreeAgentRB is a Ruby library for interacting with the FreeAgent v2 API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "freeagentrb"
```

## Usage

### Set Client Details

Firstly you'll need to set an Access Token, which would be created from OAuth.
See [this page](https://dev.freeagent.com/docs/quick_start) for more info.

```ruby
@client = FreeAgent::Client.new(access_token: "", sandbox: true)
```

### Rate Limiting

The library automatically tracks rate limiting based on the FreeAgent API's `Retry-After` header when you receive a 429 (Too Many Requests) response. You can access rate limit information through the client's rate limiter:

```ruby
# Initialize with optional logger
require "logger"
logger = Logger.new($stdout)
@client = FreeAgent::Client.new(access_token: "", sandbox: true, logger: logger)

# Check rate limit status
@client.rate_limiter.status
# => "Not rate limited" or "Rate limited. Retry in 60 seconds"

# Check if currently rate limited
@client.rate_limiter.rate_limited?
# => true/false

# Get seconds until rate limit resets
@client.rate_limiter.reset_in
# => 60 (seconds remaining)

# Manually wait if rate limited
@client.rate_limiter.wait_if_rate_limited
```

For testing rate limiting in the sandbox, enable the `X-RateLimit-Test` header:

```ruby
# This artificially lowers sandbox API calls to 5 requests/minute
@client = FreeAgent::Client.new(
  access_token: "",
  sandbox: true,
  enable_rate_limit_test: true
)
```

### OAuth

This library includes the ability to create, refresh and revoke OAuth tokens.

```ruby
# Firstly, set the client details
@oauth = FreeAgent::OAuth.new(sandbox: true, client_id: "", client_secret: "")

# Generate an authorisation URL
# state can be nil
@oauth.authorise_url(redirect: "https://mysite.com/auth", state: "something")

# Create a Token from the authorisation code
@oauth.create(token: "abc123", redirect: "https://mysite.com/auth")

# Refresh a Token
@oauth.refresh(refresh_token: "abc123")
```

### Accountancy Practice API

If you've authenticated as an accountancy practice, you can list the clients
your practice has access to and make requests on their behalf. See
[the FreeAgent docs](https://dev.freeagent.com/docs/accountancy_practice_api)
for more info.

These endpoints are only available to practice-level access tokens. If each of
your users connected their own FreeAgent account via OAuth, you don't need any
of this — their token is already scoped to their company.

#### Practice details

```ruby
@client.practice.retrieve
# => #<FreeAgent::Practice name="My Practice", subdomain="mypracticesubdomain">
```

#### Clients

```ruby
@client.clients.list
@client.clients.list(view: "active")
@client.clients.list(sort: "-created_at")
@client.clients.list(updated_since: "2026-01-01T00:00:00Z")

# Fetch only the id, name and subdomain, up to 500 per page
@client.clients.list(minimal_data: true, per_page: 500)
```

`view` accepts `all`, `active`, `inactive`, `closed`, `practice`, `linked`,
`copilot` and `demo`. `sort` accepts `created_at` and `updated_at`, prefixed
with `-` for descending order. `from_date` and `to_date` are also supported.

#### Account managers

```ruby
@client.account_managers.list
@client.account_managers.retrieve(id: "123")
```

#### Making requests on behalf of a client

Requests are scoped to one of your clients by sending its subdomain in the
`X-Subdomain` header. Set it when building the client:

```ruby
@client = FreeAgent::Client.new(access_token: "", subdomain: "testcompany")

# Every request is now made against that client's account
@client.invoices.list
@client.contacts.list
```

Or derive a scoped client from your practice-level one, which is handy when
iterating over several clients:

```ruby
@practice = FreeAgent::Client.new(access_token: "")

@practice.clients.list(minimal_data: true).each do |client|
  @practice.on_behalf_of(client.subdomain).invoices.list
end
```

`on_behalf_of` returns a new client and leaves the original untouched, so the
practice-level client can still be used for `clients`, `account_managers` and
`practice`.

### Bank Accounts

```ruby
@client.bank_accounts.list
@client.bank_accounts.list(view: "paypal_accounts")
@client.bank_accounts.retrieve(id: "12345")
@client.bank_accounts.create type: "StandardBankAccount", name: "My Account", opening_balance: "10"
@client.bank_accounts.update id: "12345", name: "My Other Account"
```
