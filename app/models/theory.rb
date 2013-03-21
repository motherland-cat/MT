# == Schema Information
#
# Table name: theories
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  chapter_id :integer
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  online     :boolean          default(FALSE)
#

class Theory < ActiveRecord::Base
  attr_accessible :content, :position, :title, :online
  belongs_to :chapter
  has_and_belongs_to_many :users
  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true, length: { maximum: 8000 }
  validates :position, presence: true,
    uniqueness: { scope: :chapter_id },
    numericality: { greater_than_or_equal_to: 0 }
end
