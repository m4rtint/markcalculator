class User < ActiveRecord::Base
    has_many :term, :dependent => :destroy

    # def self.sign_in_from_omniauth(auth)
    #     find_by(provider: auth['provider'], uid: auth['uid']) || create_user_from_omniauth(auth)
    # end
    #
    # def self.create_user_from_omniauth(auth)
    #     create(
    #         provider: auth['provider'],
    #         uid: auth['uid'],
    #         name: auth['info']['name'],
    #         oauth_token: auth['credentials']['token'],
    #         oauth_expires_at: Time.at(auth['credentials']['expires_at'])
    #     )
    # end

    def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
end
