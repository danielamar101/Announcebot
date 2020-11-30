class Announcement < ApplicationRecord
  validates_presence_of :announcementText
  validates_presence_of :date
  validates_presence_of :time
  validates_presence_of :title
end
