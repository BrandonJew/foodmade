class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def account_deactivation(user)
    @user = user
    mail to: user.email, subject: "Account deactivation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

  def chef_confirmation(user)
    @user = user
    mail to: user.email, subject: "Congratulations, you are a FoodMade Chef!"
  end

  def chef_notification(user)
    @user = user
    mail to: user.email, subject: "You are no longer a FoodMade Chef."
  end
end
