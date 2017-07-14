describe User do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }
end

describe "when email is not present" do
  before { @user = FactoryGirl.build(:user) }
  subject { @user }
  it { should validate_presence_of(:email) }
  it { should validate_confirmation_of(:password) }
  it { should allow_value('example@domain.com').for(:email) }
end

describe User, 'validations' do
end