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

### Bank Accounts

```ruby
@client.bank_accounts.list
@client.bank_accounts.list(view: "paypal_accounts")
@client.bank_accounts.retrieve(id: "12345")
@client.bank_accounts.create type: "StandardBankAccount", name: "My Account", opening_balance: "10"
@client.bank_accounts.update id: "12345", name: "My Other Account"
```
