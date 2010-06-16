require 'test/unit'
require 'rubygems'
begin require 'redgreen'; rescue LoadError; end
require File.dirname(__FILE__) + '/../lib/migration_fu'

class String
  def singularize; self[0...-1] end
end

class ActiveRecord::Migration
  def self.execute command; command end
end

class MigrationFuTest < Test::Unit::TestCase

  ID        = 'fk_users_files'
  CUSTOM_ID = 'fk_my_name'
  CUSTOM_FK = 'person_id'

  def setup
    @foo = ActiveRecord::Migration
  end

  def test_should_add_foreign_key_without_options
    assert_equal add_command, add
  end

  def test_should_add_foreign_key_with_invalid_options_but_ignore_them
    assert_equal add_command, add(:on_del => :ca)
  end

  def test_should_add_foreign_key_with_valid_options
    assert_equal "#{add_command} ON DELETE CASCADE", add(:on_delete => :cascade)
    assert_match(/ON DELETE CASCADE/, add(:on_update => :set_null, :on_delete => :cascade))
    assert_match(/ON UPDATE SET NULL/, add(:on_update => :set_null, :on_delete => :cascade))
  end

  def test_should_add_foreign_key_with_optional_name
    assert_equal add_command(CUSTOM_ID), add(:name => CUSTOM_ID)
  end

  #
  def test_should_add_foreign_key_with_optional_fk_field
    assert_equal add_command(CUSTOM_ID, :fk_field => CUSTOM_FK), add(:name => CUSTOM_ID, :fk_field => CUSTOM_FK)
  end

  def test_should_add_foreign_key_and_truncate_id
    to = 'x' * 70
    assert_equal add_command('fk_users_' << 'x' * 55, :to => to), @foo.add_foreign_key(:users, to.to_sym)
  end

  def test_should_remove_foreign_key
    assert_equal remove_command, remove
  end

  def test_should_remove_foreign_key_with_optional_name
    assert_equal remove_command(CUSTOM_ID), remove(:name => CUSTOM_ID)
  end

  private

  def add(options = {})
    @foo.add_foreign_key :users, :files, options
  end

  def remove(options = {})
    @foo.remove_foreign_key :users, :files, options
  end

  def add_command(id = ID, opts = {})
    opts = {:to => 'files'}.merge!(opts)
    if opts[:fk_field]
      fk = opts[:fk_field]
      id = "#{id}_#{opts[:fk_field]}"
    else
      fk = "#{opts[:to].singularize}_id"
    end
    "ALTER TABLE users ADD CONSTRAINT #{id} FOREIGN KEY(#{fk}) REFERENCES #{opts[:to]}(id)"
  end

  def remove_command(id = ID)
    "ALTER TABLE users DROP FOREIGN KEY #{id}, DROP KEY #{id}"
  end

end
