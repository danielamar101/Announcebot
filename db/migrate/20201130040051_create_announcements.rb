class CreateAnnouncements < ActiveRecord::Migration[6.0]
  def change
    create_table :announcements do |t|
      t.string :title
      t.string :announcementText
      t.string :date
      t.string :time
    end
  end
end
