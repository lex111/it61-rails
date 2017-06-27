class SocialAccount < ApplicationRecord
  belongs_to :user

  def self.from_omniauth(auth, user)
    SocialAccount.where(provider: auth.provider, uid: auth.uid).first_or_create do |s|
      s.provider = auth.provider
      s.uid = auth.uid
      s.link = link_for auth
      s.user = user
    end
  end

  # rubocop:disable Metrics/AbcSize
  def self.link_for(auth)
    provider = auth.provider

    case provider
    when "google_oauth2"
      auth.extra&.raw_info&.profile
    when "vkontakte"
      auth.info.urls&.Vkontakte
    when "facebook"
      # facebook doesn't give a link to user website
      nil
    when "github"
      auth.info.urls&.GitHub
    end
  end
end
