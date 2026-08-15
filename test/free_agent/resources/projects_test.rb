require "test_helper"

class ProjectsResourceTest < Minitest::Test
  PROJECT = {
    "url" => "https://api.freeagent.com/v2/projects/1",
    "name" => "Test Project",
    "contact" => "https://api.freeagent.com/v2/contacts/1",
    "contact_name" => "Acme Trading",
    "budget" => 0,
    "status" => "Active",
    "budget_units" => "Hours",
    "normal_billing_rate" => "0.0",
    "hours_per_day" => "8.0",
    "currency" => "GBP",
    "billing_period" => "hour",
    "is_ir35" => false
  }.freeze

  def test_list
    client = stub_client do |stubs|
      stubs.get("/v2/projects") { json({ "projects" => [ PROJECT ] }) }
    end

    projects = client.projects.list

    assert_equal FreeAgent::Collection, projects.class
    assert_equal FreeAgent::Project, projects.first.class
    assert_equal "Test Project", projects.first.name
    assert_equal false, projects.first.is_ir35
  end

  def test_list_for_contact
    client = stub_client do |stubs|
      stubs.get("/v2/projects?contact=https://api.freeagent.com/v2/contacts/1") do
        json({ "projects" => [ PROJECT ] })
      end
    end

    projects = client.projects.list_for_contact(contact: "https://api.freeagent.com/v2/contacts/1")

    assert_equal "Acme Trading", projects.first.contact_name
  end

  def test_retrieve
    client = stub_client do |stubs|
      stubs.get("/v2/projects/1") { json({ "project" => PROJECT }) }
    end

    project = client.projects.retrieve(id: 1)

    assert_equal FreeAgent::Project, project.class
    assert_equal "Hours", project.budget_units
  end

  def test_create_sends_required_attributes
    body = nil
    client = stub_client do |stubs|
      stubs.post("/v2/projects") do |env|
        body = JSON.parse(env.body)
        json({ "project" => PROJECT }, status: 201)
      end
    end

    project = client.projects.create(
      contact: "https://api.freeagent.com/v2/contacts/1",
      name: "Test Project",
      status: "Active",
      currency: "GBP",
      budget_units: "Hours"
    )

    assert_equal "Test Project", body["name"]
    assert_equal "Active", body["status"]
    assert_equal "Hours", body["budget_units"]
    assert_equal FreeAgent::Project, project.class
  end

  def test_update
    client = stub_client do |stubs|
      stubs.put("/v2/projects/1") { json({ "project" => PROJECT.merge("name" => "Renamed") }) }
    end

    assert_equal "Renamed", client.projects.update(id: 1, name: "Renamed").name
  end

  def test_delete
    client = stub_client do |stubs|
      stubs.delete("/v2/projects/1") { json({}) }
    end

    assert_equal true, client.projects.delete(id: 1)
  end
end
