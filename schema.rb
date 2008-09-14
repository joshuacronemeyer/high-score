require 'active_record'

ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table 'players', :force => true do |t|
    t.column :name, :string
  end
end

ActiveRecord::Schema.define do
  create_table 'scores', :force => true do |t|
    t.column :score, :integer
    t.column :machine_id, :integer
    t.column :player_id, :integer
  end
end

ActiveRecord::Schema.define do
  create_table 'machines', :force => true do |t|
    t.column :name, :string
  end
end
