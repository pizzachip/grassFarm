defprotocol Durations.Duration do

  def retrieve_heat(adapter)
  def retrieve_rain(adapter)
  def retrieve_human_ass(adapter)
  def retrieve_last_water(adapter) 

end
