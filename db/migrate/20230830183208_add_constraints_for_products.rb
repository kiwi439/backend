class AddConstraintsForProducts < ActiveRecord::Migration[5.2]
  def up
    change_column_null :products, :name, false
    change_column_null :products, :price, false
    change_column_null :products, :available_quantity, false
    change_column_null :products, :picture_path, false
    change_column_null :products, :product_category_id, false

    execute <<-SQL
      ALTER TABLE products
      ADD CONSTRAINT name_length_check CHECK (length(name) > 0);
    SQL

    execute <<-SQL
      ALTER TABLE products
      ADD CONSTRAINT picture_path_length_check CHECK (length(picture_path) > 0);
    SQL

    execute <<-SQL
      ALTER TABLE products
      ADD CONSTRAINT price_numericality_check CHECK (price >= 0);
    SQL

    execute <<-SQL
      ALTER TABLE products
      ADD CONSTRAINT available_quantity_check CHECK (available_quantity >= 0);
    SQL
  end

  def down
    change_column_null :products, :name, true
    change_column_null :products, :price, true
    change_column_null :products, :available_quantity, true
    change_column_null :products, :picture_path, true
    change_column_null :products, :product_category_id, true

    execute <<-SQL
      ALTER TABLE products
      DROP CONSTRAINT name_length_check;
    SQL

    execute <<-SQL
      ALTER TABLE products
      DROP CONSTRAINT picture_path_length_check;
    SQL

    execute <<-SQL
      ALTER TABLE products
      DROP CONSTRAINT price_numericality_check;
    SQL

    execute <<-SQL
      ALTER TABLE products
      DROP CONSTRAINT available_quantity_check;
    SQL
  end
end
