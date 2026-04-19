# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_04_19_130000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "newsletters", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.string "surname", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_newsletters_on_email", unique: true
    t.check_constraint "length(email::text) > 0", name: "email_check"
    t.check_constraint "length(name::text) > 0", name: "name_check"
    t.check_constraint "length(surname::text) > 0", name: "surname_check"
  end

  create_table "opinions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "content"
    t.integer "mark", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_opinions_on_user_id"
    t.check_constraint "length(content) > 0", name: "content_check"
    t.check_constraint "mark >= 1 AND mark <= 5", name: "mark_range_check"
  end

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "surname", null: false
    t.string "phone_number", null: false
    t.string "street", null: false
    t.string "city", null: false
    t.string "postal_code", null: false
    t.string "delivery_method", null: false
    t.string "payment_method", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "email", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
    t.check_constraint "length(city::text) > 0", name: "city_length_check"
    t.check_constraint "length(delivery_method::text) > 0", name: "delivery_method_length_check"
    t.check_constraint "length(email::text) > 0", name: "email_length_check"
    t.check_constraint "length(name::text) > 0", name: "name_length_check"
    t.check_constraint "length(payment_method::text) > 0", name: "payment_method_length_check"
    t.check_constraint "length(phone_number::text) > 0", name: "phone_number_length_check"
    t.check_constraint "length(postal_code::text) > 0", name: "postal_code_length_check"
    t.check_constraint "length(street::text) > 0", name: "street_length_check"
    t.check_constraint "length(surname::text) > 0", name: "surname_length_check"
  end

  create_table "payments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "order_id", null: false
    t.string "status", default: "pending", null: false
    t.string "provider", null: false
    t.integer "amount_cents", null: false
    t.jsonb "provider_data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
  end

  create_table "product_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.check_constraint "length(name::text) > 0", name: "name_length_check"
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.float "price", null: false
    t.integer "available_quantity", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.uuid "product_category_id", null: false
    t.datetime "promoted_from", precision: nil
    t.datetime "promoted_to", precision: nil
    t.string "picture_key", limit: 120, null: false
    t.string "picture_bucket", limit: 120, null: false
    t.index ["product_category_id"], name: "index_products_on_product_category_id"
    t.check_constraint "available_quantity >= 0", name: "available_quantity_check"
    t.check_constraint "length(name::text) > 0", name: "name_length_check"
    t.check_constraint "price >= 0::double precision", name: "price_numericality_check"
  end

  create_table "products_orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "order_id", null: false
    t.uuid "product_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "product_quantity", null: false
    t.index ["order_id"], name: "index_products_orders_on_order_id"
    t.index ["product_id"], name: "index_products_orders_on_product_id"
    t.check_constraint "product_quantity >= 0", name: "product_quantity_check"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.hstore "avatars", default: [], array: true
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "name"
    t.string "surname"
    t.string "phone_number"
    t.string "street"
    t.string "city"
    t.string "postal_code"
    t.check_constraint "length(city::text) > 0", name: "city_length_check"
    t.check_constraint "length(email::text) > 0", name: "email_length_check"
    t.check_constraint "length(name::text) > 0", name: "name_length_check"
    t.check_constraint "length(phone_number::text) > 0", name: "phone_number_length_check"
    t.check_constraint "length(postal_code::text) > 0", name: "postal_code_length_check"
    t.check_constraint "length(street::text) > 0", name: "street_length_check"
    t.check_constraint "length(surname::text) > 0", name: "surname_length_check"
  end

  add_foreign_key "opinions", "users"
  add_foreign_key "orders", "users"
  add_foreign_key "orders", "users", name: "orders_user_id_fkey"
  add_foreign_key "payments", "orders"
  add_foreign_key "products", "product_categories"
  add_foreign_key "products_orders", "orders"
  add_foreign_key "products_orders", "products"
end
