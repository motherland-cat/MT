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

require 'spec_helper'

describe Problem do
  before { @p = FactoryGirl.build(:problem) }

  subject { @p }

  it { should respond_to(:statement) }
  it { should respond_to(:position) }
  it { should respond_to(:chapter) }
  it { should respond_to(:name) }
  it { should respond_to(:online) }

  it { should be_valid }

  # Name
  describe "when name is not present" do
    before { @p.name = " " }
    it { should_not be_valid }
  end
  describe "when name is too long" do
    before { @p.name = "a" * 256 }
    it { should_not be_valid }
  end

  # Statement
  describe "when statement is not present" do
    before { @p.statement = " " }
    it { should_not be_valid }
  end
  describe "when statement is too long" do
    before { @p.statement = "a" * 8001 }
    it { should_not be_valid }
  end

  # Position
  describe "when position is not present" do
    before { @p.position = nil }
    it { should_not be_valid }
  end
  describe "when position is negative" do
    before { @p.position = -1 }
    it { should_not be_valid }
  end
  describe "when position is already taken with the same chapter" do
    before { FactoryGirl.create(:problem,
                                chapter: @p.chapter,
                                position: @p.position) }
    it { should_not be_valid }
  end
  describe "when position is already taken with a different chapter" do
    before { FactoryGirl.create(:problem,
                                position: @p.position) }
    it { should be_valid }
  end

end
