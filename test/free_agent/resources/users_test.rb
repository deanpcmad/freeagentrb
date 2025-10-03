require "test_helper"

class UsersResourceTest < Minitest::Test
  def test_users_me
    setup_client
    me = @client.users.me

    assert_equal FreeAgent::User, me.class
    assert_equal "Dean", me.first_name
  end

  def test_users_list
    setup_client
    users = @client.users.list

    assert_equal FreeAgent::Collection, users.class
    assert_equal FreeAgent::User, users.first.class
  end

  def test_users_retrieve
    setup_client
    user = @client.users.retrieve(id: 32912)

    assert_equal FreeAgent::User, user.class
    assert_equal "Dean", user.first_name
  end
end
