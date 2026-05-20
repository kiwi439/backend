class AddConstraintsForNewsletters < ActiveRecord::Migration[5.2]
  def up
    change_column_null :newsletters, :name, false
    change_column_null :newsletters, :surname, false
    change_column_null :newsletters, :email, false

    execute <<-SQL
      ALTER TABLE newsletters
      ADD CONSTRAINT name_check
      CHECK (length(name) > 0);
    SQL

    execute <<-SQL
      ALTER TABLE newsletters
      ADD CONSTRAINT surname_check
      CHECK (length(surname) > 0);
    SQL

    execute <<-SQL
      ALTER TABLE newsletters
      ADD CONSTRAINT email_check
      CHECK (length(email) > 0);
    SQL

    add_index :newsletters, :email, unique: true
  end

  def down
    change_column_null :newsletters, :name, true
    change_column_null :newsletters, :surname, true
    change_column_null :newsletters, :email, true

    execute <<-SQL
      ALTER TABLE newsletters
      DROP CONSTRAINT name_check;
    SQL

    execute <<-SQL
      ALTER TABLE newsletters
      DROP CONSTRAINT surname_check;
    SQL

    execute <<-SQL
      ALTER TABLE newsletters
      DROP CONSTRAINT email_check;
    SQL

    remove_index :newsletters, :email
  end
end
