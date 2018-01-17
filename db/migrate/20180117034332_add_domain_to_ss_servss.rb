class AddDomainToSsServss < ActiveRecord::Migration[5.0]
  def change
    add_column :ss_items, :domain, :string
    add_column :ss_services, :domain, :string
  end
end
