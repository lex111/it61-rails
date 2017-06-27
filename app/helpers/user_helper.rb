module UserHelper
  def users_fit_on_one_page?(users)
    users.count <= Settings.per_page.users
  end

  def my_profile?(user)
    user == current_user
  end

  def social_account_linked(user, provider)
    if linked user, provider
      "button-linked"
    else
      "button-not-linked"
    end
  end

  def all_providers
    {
      facebook: {
        name: t("socials.facebook"),
        class: "fa fa-facebook",
        buttonclass: "btn btn-fb",
        link: "/users/auth/facebook",
      },
      google_oauth2: {
        name: t("socials.google_plus"),
        class: "fa fa-google-plus",
        buttonclass: "btn btn-google",
        link: "/users/auth/google_oauth2",
      },
      vkontakte: {
        name: t("socials.vk"),
        class: "fa fa-vk",
        buttonclass: "btn btn-vk",
        link: "/users/auth/vkontakte",
      },
      github: {
        name: t("socials.github"),
        class: "fa fa-github",
        buttonclass: "btn btn-github",
        link: "/users/auth/github",
      },
    }
  end

  def provider_buttons_info(user)
    accounts = user.social_accounts
    res = {}
    accounts.each do |a|
      provider = a.provider.to_sym
      link = a.link
      button_class = all_providers[provider][:class]
      res[provider] = [link, button_class] unless link.nil?
    end
    res
  end

  def linked_providers(user)
    select_providers user do |linked, p|
      linked.include? p.to_s
    end
  end

  def not_linked_providers(user)
    select_providers user do |linked, p|
      !(linked.include? p.to_s)
    end
  end

  def default_avatar_url
    CGI.escape(image_url("user_default.svg"))
  end

  def photo(user)
    user.avatar.file.nil? ? image_url("user_default.png") : user.avatar.square_500
  end

  private

  def linked(user, provider)
    user.social_accounts.exists?(provider: provider)
  end

  def select_providers(user)
    linked = user.social_accounts.pluck :provider
    all_providers.select do |p, _|
      yield linked, p
    end
  end
end
