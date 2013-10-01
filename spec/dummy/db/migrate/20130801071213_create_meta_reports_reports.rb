class CreateMetaReportsReports < ActiveRecord::Migration
  def change
    create_table :meta_reports_reports do |t|
      t.string  :name
      t.text    :description
      t.string  :title
      t.string  :group
      t.boolean :direct
      t.integer :views
      t.string  :target
      t.integer :formats_mask

      t.timestamps
    end
    # add_index :meta_reports_reports, :name
  end
end
