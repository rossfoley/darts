class User < ActiveRecord::Base
  devise :omniauthable, omniauth_providers:  [:google_oauth2]

  def self.from_omniauth(auth)
    where(uid: auth.uid).first_or_create do |user|
      user.uid = auth.uid
      user.email = auth.info.email
    end
  end
end
