defprotocol GrassFarm.ZoneControl do
  def start(adapter)
  def stop(adapter)
  def check_status(adapter)
end
