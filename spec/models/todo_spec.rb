require 'rails_helper'

RSpec.describe Todo, type: :model do
  # TodoモデルはItemモデルと１対多の関係にある
  it { should have_many(:items).dependent(:destroy) }
  # タイトルがない場合は無効な状態である
  it { should validate_presence_of(:title) }
  # created_byがない場合は無効な状態である
  it { should validate_presence_of(:created_by) }
end
