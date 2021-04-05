require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "product_expired_notice" do
    mail = UserMailer.product_expired_notice
    assert_equal "Product expired notice", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
