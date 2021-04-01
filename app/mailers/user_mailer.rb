# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailer < ApplicationMailer

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/project_expired_notice
  def project_expired_notice
    @project = params[:project]

    mail to: @project.user.email, subject: "Your project has expired"
  end

end
