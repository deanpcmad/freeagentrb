require "test_helper"

class ContactsResourceTest < Minitest::Test
  def test_contacts_list
    setup_client
    contacts = @client.contacts.list

    assert_equal FreeAgent::Collection, contacts.class
    assert_equal FreeAgent::Contact, contacts.first.class
  end

  def test_contacts_retrieve
    setup_client
    contacts = @client.contacts.list
    contact = @client.contacts.retrieve(id: contacts.first.id)

    assert_equal FreeAgent::Contact, contact.class
    assert_equal contacts.first.id, contact.id
    assert_equal "Dunder Mifflin", contact.organisation_name
  end

  def test_contacts_create
    setup_client
    contact = @client.contacts.create(first_name: "Dwight", last_name: "Schrute")

    assert_equal FreeAgent::Contact, contact.class
    assert_equal "Dwight", contact.first_name
    assert_equal "Schrute", contact.last_name
  end

  def test_contacts_update
    setup_client
    contact = @client.contacts.create(first_name: "Dwight", last_name: "Schrute")
    updated_contact = @client.contacts.update(id: contact.id, first_name: "Dwight Kurt", last_name: "Schrute")

    assert_equal FreeAgent::Contact, updated_contact.class
    assert_equal "Dwight Kurt", updated_contact.first_name
    assert_equal "Schrute", updated_contact.last_name
  end

  def test_contacts_delete
    setup_client
    contact = @client.contacts.create(first_name: "Dwight", last_name: "Schrute")
    result = @client.contacts.delete(id: contact.id)

    assert_equal true, result
  end

end
