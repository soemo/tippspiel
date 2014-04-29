class ExternLinksCell < Cell::Rails
  cache :show #Cache fuer immer

  def show(args)
    render
  end

end
