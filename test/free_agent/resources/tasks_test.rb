require "test_helper"

class TasksResourceTest < Minitest::Test
  TASK = {
    "url" => "https://api.freeagent.com/v2/tasks/1",
    "project" => "https://api.freeagent.com/v2/projects/1",
    "name" => "Sample Task",
    "currency" => "GBP",
    "is_billable" => true,
    "billing_rate" => "0.0",
    "billing_period" => "hour",
    "status" => "Active"
  }.freeze

  def test_list
    client = stub_client do |stubs|
      stubs.get("/v2/tasks") { json({ "tasks" => [ TASK ] }) }
    end

    tasks = client.tasks.list

    assert_equal FreeAgent::Collection, tasks.class
    assert_equal FreeAgent::Task, tasks.first.class
    assert_equal "Sample Task", tasks.first.name
    assert_equal true, tasks.first.is_billable
  end

  def test_list_for_project
    client = stub_client do |stubs|
      stubs.get("/v2/tasks?project=https://api.freeagent.com/v2/projects/1") do
        json({ "tasks" => [ TASK ] })
      end
    end

    assert_equal 1, client.tasks.list_for_project(project: "https://api.freeagent.com/v2/projects/1").count
  end

  def test_retrieve
    client = stub_client do |stubs|
      stubs.get("/v2/tasks/1") { json({ "task" => TASK }) }
    end

    task = client.tasks.retrieve(id: 1)

    assert_equal FreeAgent::Task, task.class
    assert_equal "Active", task.status
  end

  def test_create_sends_required_attributes
    body = nil
    client = stub_client do |stubs|
      stubs.post("/v2/tasks") do |env|
        body = JSON.parse(env.body)
        json({ "task" => TASK }, status: 201)
      end
    end

    task = client.tasks.create(
      project: "https://api.freeagent.com/v2/projects/1",
      name: "Sample Task",
      currency: "GBP",
      is_billable: true,
      status: "Active"
    )

    assert_equal "Sample Task", body["name"]
    assert_equal "https://api.freeagent.com/v2/projects/1", body["project"]
    assert_equal FreeAgent::Task, task.class
  end

  def test_update
    client = stub_client do |stubs|
      stubs.put("/v2/tasks/1") { json({ "task" => TASK.merge("name" => "Renamed") }) }
    end

    assert_equal "Renamed", client.tasks.update(id: 1, name: "Renamed").name
  end

  def test_delete
    client = stub_client do |stubs|
      stubs.delete("/v2/tasks/1") { json({}) }
    end

    assert_equal true, client.tasks.delete(id: 1)
  end
end
