require 'rails_helper'

RSpec.describe Item, type: :model do
  # Itemレコードはただ一つのtodoレコードに属する
  it { should belong_to(:todo) }
  # nameがない場合は無効な状態である
  it { should validate_presence_of(:name) }
end
