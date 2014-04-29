class ExternLinksCell < Cell::Rails
  cache :show #Cache fuer immer

  def show
    render
  end

end
