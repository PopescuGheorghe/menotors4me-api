RSpec.describe Organization, type: :model do
  context 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:asignee) }
    it { is_expected.to respond_to(:phone_number) }
    it { is_expected.to respond_to(:city) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:asignee) }
    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to belong_to(:user) }
  end
end
