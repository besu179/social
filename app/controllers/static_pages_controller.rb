class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def about
  end

  def contact
  end

  def settings
    @title = "Settings"
  end

  def privacy
    @title = "Privacy Policy"
  end
end
