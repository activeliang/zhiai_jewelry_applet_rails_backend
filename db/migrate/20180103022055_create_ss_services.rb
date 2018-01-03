class CreateSsServices < ActiveRecord::Migration[5.0]
  def change
    create_table :ss_services do |t|
      t.text :ss_conf, :ss_json
      t.string :service_ip
      t.timestamps
    end
  end
end
