module ApplicationService
  def call(params)
    new(params).call
  end
end
