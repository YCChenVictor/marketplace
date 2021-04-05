# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/product_expired_notice
  def product_expired_notice
    UserMailer.product_expired_notice
  end

end
