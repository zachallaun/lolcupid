class PagesController < ApplicationController
  def index
    render layout: "index"
  end

  def about
    render layout: "about"
  end

  def summoner
  end

  def champions
  end
end
