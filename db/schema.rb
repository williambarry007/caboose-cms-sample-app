# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150211111401) do

  create_table "ab_options", :force => true do |t|
    t.integer "ab_variant_id"
    t.string  "value"
  end

  create_table "ab_values", :force => true do |t|
    t.string  "session_id"
    t.integer "ab_variant_id"
    t.integer "ab_option_id"
  end

  create_table "ab_variants", :force => true do |t|
    t.string "name"
    t.string "analytics_name"
  end

  create_table "assets", :force => true do |t|
    t.integer  "page_id"
    t.integer  "user_id"
    t.datetime "date_uploaded"
    t.string   "name"
    t.string   "filename"
    t.string   "description"
    t.string   "extension"
  end

  create_table "block_type_categories", :force => true do |t|
    t.integer "parent_id"
    t.string  "name"
  end

  create_table "block_type_site_memberships", :force => true do |t|
    t.integer "site_id"
    t.integer "block_type_id"
  end

  create_table "block_type_sources", :force => true do |t|
    t.string  "name"
    t.string  "url"
    t.string  "token"
    t.integer "priority", :default => 0
    t.boolean "active",   :default => true
  end

  create_table "block_type_summaries", :force => true do |t|
    t.integer "block_type_source_id"
    t.string  "name"
    t.string  "description"
  end

  create_table "block_types", :force => true do |t|
    t.integer "parent_id"
    t.string  "name"
    t.string  "description"
    t.text    "render_function"
    t.boolean "use_render_function",            :default => false
    t.boolean "use_render_function_for_layout", :default => false
    t.boolean "allow_child_blocks",             :default => false
    t.string  "field_type"
    t.text    "default"
    t.integer "width"
    t.integer "height"
    t.boolean "fixed_placeholder"
    t.text    "options"
    t.text    "options_function"
    t.string  "options_url"
    t.integer "block_type_category_id",         :default => 2
    t.boolean "share",                          :default => true
    t.boolean "downloaded",                     :default => false
    t.string  "icon"
    t.boolean "is_global",                      :default => false
    t.integer "default_child_block_type_id"
  end

  add_index "block_types", ["parent_id"], :name => "index_block_types_on_parent_id"

  create_table "blocks", :force => true do |t|
    t.integer  "page_id"
    t.integer  "parent_id"
    t.integer  "block_type_id"
    t.integer  "sort_order",         :default => 0
    t.string   "name"
    t.text     "value"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "blocks", ["parent_id"], :name => "index_blocks_on_parent_id"

  create_table "caboose_store_configs", :force => true do |t|
    t.integer "site_id"
    t.string  "pp_name"
    t.string  "pp_username"
    t.string  "pp_password"
    t.boolean "use_usps",               :default => false
    t.string  "usps_secret_key"
    t.string  "usps_publishable_key"
    t.string  "allowed_shipping_codes"
    t.string  "default_shipping_code"
    t.string  "origin_country"
    t.string  "origin_state"
    t.string  "origin_city"
    t.string  "origin_zip"
    t.string  "fulfillment_email"
    t.string  "shipping_email"
    t.string  "handling_percentage"
  end

  create_table "calendar_event_groups", :force => true do |t|
    t.integer "frequency",    :default => 1
    t.string  "period",       :default => "Week"
    t.string  "repeat_by"
    t.boolean "sun",          :default => false
    t.boolean "mon",          :default => false
    t.boolean "tue",          :default => false
    t.boolean "wed",          :default => false
    t.boolean "thu",          :default => false
    t.boolean "fri",          :default => false
    t.boolean "sat",          :default => false
    t.date    "date_start"
    t.integer "repeat_count"
    t.date    "date_end"
  end

  create_table "calendar_events", :force => true do |t|
    t.integer  "calendar_id"
    t.integer  "calendar_event_group_id"
    t.string   "name"
    t.text     "description"
    t.string   "location"
    t.datetime "begin_date"
    t.datetime "end_date"
    t.boolean  "all_day",                 :default => false
    t.boolean  "repeats",                 :default => false
  end

  create_table "calendars", :force => true do |t|
    t.integer "site_id"
    t.string  "name"
    t.text    "description"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "domains", :force => true do |t|
    t.integer "site_id"
    t.string  "domain"
    t.boolean "primary",            :default => false
    t.boolean "under_construction", :default => false
  end

  create_table "facebook_caches", :force => true do |t|
    t.integer "site_id"
    t.string  "page_name"
    t.string  "page_url"
    t.text    "profile_img"
    t.text    "post_id"
    t.text    "post_url"
    t.text    "link"
    t.text    "story"
    t.text    "message"
    t.text    "picture"
    t.string  "date_created"
    t.text    "page_id"
  end

  create_table "instagram_caches", :force => true do |t|
    t.integer "site_id"
    t.string  "image_url"
    t.string  "link_url"
    t.string  "instagram_id"
    t.string  "username"
    t.text    "caption"
    t.string  "location"
    t.string  "date_created"
  end

  create_table "media_categories", :force => true do |t|
    t.integer "parent_id"
    t.integer "site_id"
    t.string  "name"
  end

  create_table "media_files", :force => true do |t|
    t.integer  "media_category_id"
    t.string   "name"
    t.text     "description"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "media_images", :force => true do |t|
    t.integer  "media_category_id"
    t.string   "name"
    t.text     "description"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "page_cache", :force => true do |t|
    t.integer "page_id"
    t.text    "render_function"
    t.binary  "block"
    t.boolean "refresh",         :default => false
  end

  create_table "page_permissions", :force => true do |t|
    t.integer "role_id"
    t.integer "page_id"
    t.string  "action"
  end

  create_table "page_tags", :force => true do |t|
    t.integer "page_id"
    t.string  "tag"
  end

  create_table "pages", :force => true do |t|
    t.integer "parent_id"
    t.string  "title"
    t.string  "menu_title"
    t.string  "slug"
    t.string  "alias"
    t.string  "uri"
    t.string  "redirect_url"
    t.boolean "hide",                                :default => false
    t.integer "content_format",                      :default => 1
    t.text    "custom_css"
    t.text    "custom_js"
    t.text    "linked_resources"
    t.string  "layout"
    t.integer "sort_order",                          :default => 0
    t.boolean "custom_sort_children",                :default => false
    t.string  "seo_title",            :limit => 70
    t.string  "meta_description",     :limit => 156
    t.string  "meta_robots",                         :default => "index, follow"
    t.string  "canonical_url"
    t.string  "fb_description",       :limit => 156
    t.string  "gp_description",       :limit => 156
    t.integer "site_id"
    t.text    "meta_keywords"
  end

  create_table "permanent_redirects", :force => true do |t|
    t.integer "site_id"
    t.integer "priority", :default => 0
    t.boolean "is_regex", :default => false
    t.string  "old_url"
    t.string  "new_url"
  end

  create_table "permissions", :force => true do |t|
    t.string "resource"
    t.string "action"
  end

  create_table "post_categories", :force => true do |t|
    t.string  "name"
    t.integer "site_id"
  end

  create_table "post_category_memberships", :force => true do |t|
    t.integer "post_id"
    t.integer "post_category_id"
  end

  add_index "post_category_memberships", ["post_category_id"], :name => "index_post_category_memberships_on_post_category_id"
  add_index "post_category_memberships", ["post_id"], :name => "index_post_category_memberships_on_post_id"

  create_table "posts", :force => true do |t|
    t.text     "title"
    t.text     "body"
    t.boolean  "hide"
    t.text     "image_url"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "site_id"
  end

  create_table "role_memberships", :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "role_memberships", ["role_id"], :name => "index_role_memberships_on_role_id"
  add_index "role_memberships", ["user_id"], :name => "index_role_memberships_on_user_id"

  create_table "role_permissions", :force => true do |t|
    t.integer "role_id"
    t.integer "permission_id"
  end

  add_index "role_permissions", ["permission_id"], :name => "index_role_permissions_on_permission_id"
  add_index "role_permissions", ["role_id"], :name => "index_role_permissions_on_role_id"

  create_table "roles", :force => true do |t|
    t.integer "parent_id"
    t.string  "name"
    t.string  "description"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.string  "name"
    t.text    "value"
    t.integer "site_id"
  end

  create_table "site_membership", :force => true do |t|
    t.integer "site_id"
    t.integer "user_id"
    t.string  "role"
  end

  create_table "sites", :force => true do |t|
    t.string  "name"
    t.text    "description"
    t.text    "under_construction_html"
    t.boolean "use_store",               :default => false
  end

  create_table "smtp_configs", :force => true do |t|
    t.integer "site_id"
    t.string  "address",              :default => "localhost"
    t.integer "port",                 :default => 25
    t.string  "domain"
    t.string  "user_name"
    t.string  "password"
    t.string  "authentication"
    t.boolean "enable_starttls_auto", :default => true
  end

  create_table "social_configs", :force => true do |t|
    t.integer "site_id"
    t.string  "facebook_page_id"
    t.string  "twitter_username"
    t.string  "instagram_username"
    t.string  "youtube_url"
    t.string  "pinterest_url"
    t.string  "vimeo_url"
    t.string  "rss_url"
    t.string  "google_plus_url"
    t.string  "linkedin_url"
  end

  create_table "store_addresses", :force => true do |t|
    t.string "name"
    t.string "first_name"
    t.string "last_name"
    t.string "street"
    t.string "address1"
    t.string "address2"
    t.string "company"
    t.string "city"
    t.string "state"
    t.string "province"
    t.string "province_code"
    t.string "zip"
    t.string "country"
    t.string "country_code"
    t.string "phone"
  end

  create_table "store_categories", :force => true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.string   "url"
    t.string   "slug"
    t.string   "status"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "square_offset_x"
    t.integer  "square_offset_y"
    t.decimal  "square_scale_factor"
    t.integer  "sort_order"
    t.integer  "site_id"
    t.string   "alternate_id"
  end

  create_table "store_category_memberships", :force => true do |t|
    t.integer "category_id"
    t.integer "product_id"
  end

  create_table "store_configs", :force => true do |t|
    t.integer "site_id"
    t.string  "pp_name"
    t.string  "pp_username"
    t.string  "pp_password"
    t.string  "usps_secret_key"
    t.string  "usps_publishable_key"
    t.string  "origin_country"
    t.string  "origin_state"
    t.string  "origin_city"
    t.string  "origin_zip"
    t.string  "fulfillment_email"
    t.string  "shipping_email"
    t.string  "handling_percentage"
    t.text    "shipping_rates_function"
    t.boolean "calculate_packages",      :default => true
    t.string  "ups_username"
    t.string  "ups_password"
    t.string  "ups_key"
    t.string  "ups_origin_account"
    t.string  "usps_username"
    t.string  "fedex_username"
    t.string  "fedex_password"
    t.string  "fedex_key"
    t.string  "fedex_account"
    t.string  "length_unit",             :default => "in"
    t.string  "weight_unit",             :default => "oz"
    t.text    "order_packages_function"
    t.boolean "pp_testing",              :default => true
    t.string  "pp_relay_domain"
  end

  create_table "store_customization_memberships", :force => true do |t|
    t.integer "product_id"
    t.integer "customization_id"
  end

  create_table "store_discounts", :force => true do |t|
    t.string  "name"
    t.string  "code"
    t.decimal "amount_current"
    t.decimal "amount_total"
    t.decimal "amount_flat"
    t.decimal "amount_percentage"
    t.boolean "no_shipping"
    t.boolean "no_tax"
    t.integer "site_id"
  end

  create_table "store_gift_cards", :force => true do |t|
    t.integer  "site_id"
    t.string   "name"
    t.string   "code"
    t.string   "card_type"
    t.decimal  "total",           :precision => 8, :scale => 2
    t.decimal  "balance",         :precision => 8, :scale => 2
    t.decimal  "min_order_total", :precision => 8, :scale => 2
    t.datetime "date_available"
    t.datetime "date_expires"
    t.string   "status"
  end

  create_table "store_line_items", :force => true do |t|
    t.integer "order_id"
    t.integer "order_package_id"
    t.integer "variant_id"
    t.integer "parent_id"
    t.integer "quantity",                                       :default => 0
    t.string  "status"
    t.string  "tracking_number"
    t.decimal "price",            :precision => 8, :scale => 2
    t.text    "notes"
    t.string  "custom1"
    t.string  "custom2"
    t.string  "custom3"
  end

  create_table "store_order_discounts", :force => true do |t|
    t.integer "order_id"
    t.integer "discount_id"
    t.integer "gift_card_id"
    t.decimal "amount",       :default => 0.0
  end

  create_table "store_order_packages", :force => true do |t|
    t.integer "order_id"
    t.integer "shipping_package_id"
    t.string  "status"
    t.string  "tracking_number"
    t.integer "shipping_method_id"
    t.decimal "total",               :precision => 8, :scale => 2
  end

  create_table "store_order_transactions", :force => true do |t|
    t.integer  "order_id"
    t.datetime "date_processed"
    t.string   "transaction_type"
    t.decimal  "amount",           :precision => 8, :scale => 2
    t.string   "transaction_id"
    t.string   "auth_code"
    t.string   "response_code"
    t.boolean  "success"
  end

  create_table "store_orders", :force => true do |t|
    t.integer  "site_id"
    t.integer  "alternate_id"
    t.decimal  "subtotal",            :precision => 8, :scale => 2
    t.decimal  "tax",                 :precision => 8, :scale => 2
    t.decimal  "shipping",            :precision => 8, :scale => 2
    t.decimal  "handling",            :precision => 8, :scale => 2
    t.decimal  "custom_discount",     :precision => 8, :scale => 2
    t.decimal  "discount",            :precision => 8, :scale => 2
    t.decimal  "total",               :precision => 8, :scale => 2
    t.integer  "customer_id"
    t.string   "financial_status"
    t.integer  "shipping_address_id"
    t.integer  "billing_address_id"
    t.text     "notes"
    t.string   "status"
    t.datetime "date_created"
    t.text     "referring_site"
    t.string   "landing_page"
    t.string   "landing_page_ref"
    t.decimal  "auth_amount",         :precision => 8, :scale => 2
  end

  create_table "store_product_image_variants", :force => true do |t|
    t.integer "product_image_id"
    t.integer "variant_id"
  end

  create_table "store_product_images", :force => true do |t|
    t.integer  "product_id"
    t.string   "title"
    t.integer  "position"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "square_offset_x"
    t.integer  "square_offset_y"
    t.decimal  "square_scale_factor"
    t.string   "alternate_id"
  end

  create_table "store_products", :force => true do |t|
    t.string   "alternate_id"
    t.string   "title"
    t.string   "caption"
    t.text     "description"
    t.string   "handle"
    t.integer  "vendor_id"
    t.string   "option1"
    t.string   "option2"
    t.string   "option3"
    t.integer  "category_id"
    t.string   "status"
    t.string   "default1"
    t.string   "default2"
    t.string   "default3"
    t.string   "seo_title"
    t.string   "seo_description"
    t.datetime "date_available"
    t.text     "custom_input"
    t.integer  "sort_order"
    t.boolean  "featured",           :default => false
    t.integer  "stackable_group_id"
    t.integer  "site_id"
  end

  create_table "store_reviews", :force => true do |t|
    t.integer "product_id"
    t.string  "content"
    t.string  "name"
    t.decimal "rating"
  end

  create_table "store_search_filters", :force => true do |t|
    t.string  "url"
    t.string  "title_like"
    t.string  "search_like"
    t.integer "category_id"
    t.text    "category"
    t.text    "vendors"
    t.text    "option1"
    t.text    "option2"
    t.text    "option3"
    t.text    "prices"
  end

  create_table "store_shipping_methods", :force => true do |t|
    t.string "carrier"
    t.string "service_code"
    t.string "service_name"
  end

  create_table "store_shipping_package_methods", :force => true do |t|
    t.integer "shipping_package_id"
    t.integer "shipping_method_id"
  end

  create_table "store_shipping_packages", :force => true do |t|
    t.decimal "volume"
    t.integer "site_id"
    t.string  "name"
    t.decimal "inside_length"
    t.decimal "inside_width"
    t.decimal "inside_height"
    t.decimal "outside_length"
    t.decimal "outside_width"
    t.decimal "outside_height"
    t.decimal "empty_weight"
    t.boolean "cylinder",        :default => false
    t.integer "priority",        :default => 1
    t.decimal "flat_rate_price"
  end

  create_table "store_stackable_groups", :force => true do |t|
    t.string  "name"
    t.decimal "extra_length"
    t.decimal "extra_width"
    t.decimal "extra_height"
    t.decimal "max_length"
    t.decimal "max_width"
    t.decimal "max_height"
  end

  create_table "store_variants", :force => true do |t|
    t.string   "sku"
    t.string   "barcode"
    t.decimal  "price",               :precision => 8, :scale => 2
    t.boolean  "available"
    t.integer  "quantity_in_stock",                                 :default => 0
    t.boolean  "ignore_quantity"
    t.boolean  "allow_backorder"
    t.decimal  "weight"
    t.decimal  "length"
    t.decimal  "width"
    t.decimal  "height"
    t.decimal  "volume"
    t.boolean  "cylinder"
    t.string   "option1"
    t.string   "option2"
    t.string   "option3"
    t.boolean  "requires_shipping"
    t.boolean  "taxable"
    t.integer  "product_id"
    t.decimal  "shipping_unit_value"
    t.string   "alternate_id"
    t.string   "status"
    t.integer  "option1_sort_order"
    t.integer  "option2_sort_order"
    t.integer  "option3_sort_order"
    t.integer  "sort_order"
    t.datetime "date_sale_starts"
    t.datetime "date_sale_end"
    t.decimal  "sale_price",          :precision => 8, :scale => 2
  end

  create_table "store_vendors", :force => true do |t|
    t.string   "name"
    t.string   "status",             :default => "Active"
    t.integer  "site_id"
    t.string   "alternate_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "featured",           :default => false
  end

  create_table "subscribers", :force => true do |t|
  end

  create_table "timezone_abbreviations", :force => true do |t|
    t.string "abbreviation"
    t.string "name"
  end

  create_table "timezone_offsets", :force => true do |t|
    t.integer "timezone_id"
    t.string  "abbreviation"
    t.integer "time_start"
    t.integer "gmt_offset"
    t.boolean "dst"
  end

  create_table "timezones", :force => true do |t|
    t.string "country_code"
    t.string "name"
  end

  create_table "trello_card_members", :force => true do |t|
    t.integer "trello_card_id"
    t.integer "trello_member_id"
  end

  create_table "trello_cards", :force => true do |t|
    t.string   "trello_id"
    t.integer  "trello_list_id"
    t.string   "name"
    t.datetime "due"
    t.integer  "pos"
    t.boolean  "to_do",               :default => false
    t.boolean  "in_progress",         :default => false
    t.boolean  "waiting_on_client",   :default => false
    t.boolean  "waiting_on_internal", :default => false
    t.boolean  "quality_assurance",   :default => false
    t.boolean  "finished",            :default => false
  end

  create_table "trello_lists", :force => true do |t|
    t.string "trello_id"
    t.string "name"
  end

  create_table "trello_members", :force => true do |t|
    t.string "trello_id"
    t.string "avatar_hash"
    t.string "full_name"
    t.string "initials"
    t.string "username"
  end

  create_table "twitter_caches", :force => true do |t|
    t.integer  "site_id"
    t.text     "body"
    t.string   "tweet_id"
    t.string   "tweet_url"
    t.datetime "created_at"
    t.text     "username"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "email"
    t.string   "address"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "fax"
    t.float    "utc_offset",          :default => -5.0
    t.integer  "timezone_id"
    t.string   "password"
    t.string   "password_reset_id"
    t.datetime "password_reset_sent"
    t.string   "token"
    t.datetime "date_created"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "timezone",            :default => "Central Time (US & Canada)"
    t.boolean  "is_guest",            :default => false
    t.integer  "site_id"
    t.string   "customer_profile_id"
    t.string   "payment_profile_id"
  end

end
