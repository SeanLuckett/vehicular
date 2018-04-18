module RequestHelper
  def json(response)
    JSON.parse(response)
  end
end