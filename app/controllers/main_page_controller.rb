class MainPageController < ApplicationController
  layout 'it61-template'

  before_filter :fetch_counters

  def show
  end

  private

  def fetch_counters
    @counters ||= {
      users: User.count,
      events: Event.published.count,
      companies: Company.count
    }
  end
end
