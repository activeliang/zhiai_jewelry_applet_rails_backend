# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170918122702) do

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.integer  "weight"
    t.string   "ancestry"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ancestry", "weight"], name: "index_categories_on_ancestry_and_weight"
  end

  create_table "product_images", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "weight"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "weight"], name: "index_product_images_on_product_id_and_weight"
  end

  create_table "products", force: :cascade do |t|
    t.decimal  "price",       precision: 10, scale: 2
    t.string   "title"
    t.string   "sub_title"
    t.string   "video"
    t.text     "description"
    t.integer  "weight"
    t.integer  "category_id"
    t.boolean  "in_stock",                             default: true
    t.boolean  "index_show",                           default: false
    t.boolean  "is_hide",                              default: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.index ["category_id", "weight"], name: "index_products_on_category_id_and_weight"
    t.index ["title", "sub_title"], name: "index_products_on_title_and_sub_title"
    t.index ["weight"], name: "index_products_on_weight"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
