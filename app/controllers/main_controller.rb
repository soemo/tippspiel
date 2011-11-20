class MainController < ApplicationController

  skip_before_filter :authenticate_user!

  # Default-Controller, um zu Testen, ob das Rails3-Projekt funktioniert
  def index
    @test = "hallo hier gehts jetzt aber so richtig los"
  end

end