class User < ActiveRecord::Base
  devise :omniauthable, omniauth_providers:  [:google_oauth2]

  validate :originate_email

  def self.from_omniauth(auth)
    where(uid: auth.uid).first_or_create do |user|
      user.uid = auth.uid
      user.email = auth.info.email
    end
  end

  private

  def originate_email
    unless email =~ /originate\.com$/
      errors.add :email, 'Email must be at originate.com'
    end
  end
end
