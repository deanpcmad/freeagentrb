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

### Bank Accounts

```ruby
@client.bank_accounts.list
@client.bank_accounts.list(view: "paypal_accounts")
@client.bank_accounts.retrieve(id: "12345")
@client.bank_accounts.create type: "StandardBankAccount", name: "My Account", opening_balance: "10"
@client.bank_accounts.update id: "12345", name: "My Other Account"
```
