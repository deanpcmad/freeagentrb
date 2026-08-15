require "test_helper"

class AccountLocksResourceTest < Minitest::Test
  def test_retrieve_returns_the_account_lock
    client = stub_client do |stubs|
      stubs.get("/v2/account_locks") { json({ "account_locks" => { "locked_until" => "2026-03-31" } }) }
    end

    assert_equal "2026-03-31", client.account_locks.retrieve.locked_until
  end

  def test_update_sets_the_lock_date
    body = nil
    client = stub_client do |stubs|
      stubs.put("/v2/account_locks") do |env|
        body = JSON.parse(env.body)
        json({ "account_locks" => { "locked_until" => "2026-03-31" } })
      end
    end

    lock = client.account_locks.update(locked_until: "2026-03-31")

    assert_equal "2026-03-31", lock.locked_until
    assert_equal({ "account_locks" => { "locked_until" => "2026-03-31" } }, body)
  end

  def test_delete_returns_true
    client = stub_client do |stubs|
      stubs.delete("/v2/account_locks") { json({}) }
    end

    assert_equal true, client.account_locks.delete
  end
end
