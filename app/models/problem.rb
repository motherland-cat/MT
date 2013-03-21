# == Schema Information
#
# Table name: problems
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  statement  :text
#  chapter_id :integer
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  online     :boolean          default(FALSE)
#

class Problem < ActiveRecord::Base
  attr_accessible :name, :position, :statement, :online
  belongs_to :chapter
  validates :name, presence: true, length: { maximum: 255 }
  validates :statement, presence: true, length: { maximum: 8000 }
  validates :position, presence: true,
    uniqueness: { scope: :chapter_id },
    numericality: { greater_than_or_equal_to: 0 } 
end
