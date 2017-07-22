describe OrderMailer do
  # include EmailSpec::Helpers
  # include EmailSpec::Matchers
  include Rails.application.routes.url_helpers

  describe '.send_confirmation' do
    before(:all) do
      user = FactoryGirl.create :user, email: FFaker::Internet.email
      @order = FactoryGirl.create :order, user: user
      @user = @order.user
      @order_mailer = OrderMailer.send_confirmation(@order)
    end

    it 'should be set to be delivered to the user from the order passed in' do
      @order_mailer.should deliver_to(@user.email)
    end

    it 'should be set to be send from no-reply@marketplace.com' do
      @order_mailer.should deliver_from('no-reply@marketplace.com')
    end

    it 'should contain the user message in the mail body' do
      @order_mailer.should have_body_text(/Order: ##{@order.id}/)
    end

    it 'should have the correct subject' do
      @order_mailer.should have_subject(/Order Confirmation/)
    end

    it 'should have the products count' do
      @order_mailer.should have_body_text(/You ordered #{@order.products.count}/)
    end
  end
end