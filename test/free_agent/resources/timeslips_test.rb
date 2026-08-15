require "test_helper"

class TimeslipsResourceTest < Minitest::Test
  def test_create_wraps_payload_in_timeslip_root
    body = nil
    client = stub_client do |stubs|
      stubs.post("/v2/timeslips") do |env|
        body = JSON.parse(env.body)
        [ 201, { "Content-Type" => "application/json" }, JSON.dump({ "timeslip" => { "hours" => "12.0" } }) ]
      end
    end

    timeslip = client.timeslips.create(
      task: "https://api.freeagent.com/v2/tasks/1",
      user: "https://api.freeagent.com/v2/users/1",
      project: "https://api.freeagent.com/v2/projects/1",
      dated_on: "2011-08-15",
      hours: "12.0",
      comment: "Some work"
    )

    expected = {
      "timeslip" => {
        "task" => "https://api.freeagent.com/v2/tasks/1",
        "user" => "https://api.freeagent.com/v2/users/1",
        "project" => "https://api.freeagent.com/v2/projects/1",
        "dated_on" => "2011-08-15",
        "hours" => "12.0",
        "comment" => "Some work"
      }
    }

    assert_equal expected, body
    assert_equal "12.0", timeslip.hours
  end

  def test_update_wraps_payload_in_timeslip_root
    body = nil
    client = stub_client do |stubs|
      stubs.put("/v2/timeslips/1") do |env|
        body = JSON.parse(env.body)
        [ 200, { "Content-Type" => "application/json" }, JSON.dump({ "timeslip" => { "hours" => "8.0" } }) ]
      end
    end

    timeslip = client.timeslips.update(id: 1, hours: "8.0")

    assert_equal({ "timeslip" => { "hours" => "8.0" } }, body)
    assert_equal "8.0", timeslip.hours
  end

  def test_start_timer_posts_to_the_timer_path
    client = stub_client do |stubs|
      stubs.post("/v2/timeslips/1/timer") { json({ "timeslip" => { "hours" => "0.0" } }) }
    end

    assert_equal "0.0", client.timeslips.start_timer(id: 1).hours
  end

  def test_stop_timer_deletes_the_timer_path
    client = stub_client do |stubs|
      stubs.delete("/v2/timeslips/1/timer") { json({}) }
    end

    assert_equal true, client.timeslips.stop_timer(id: 1)
  end
end
