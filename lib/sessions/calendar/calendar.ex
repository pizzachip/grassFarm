defprotocol Sessions.Calendar do
  def get_calendar(adapter)
  def update_calendar(adapter)
  def save_calendar(adapter)
end
