defprotocol Durations.Duration do

  def retrieve_heat(adapter)
  def retrieve_rain(adapter)
  def retrieve_operator_score(adapter)
  def retrieve_last_water(adapter) 

end
