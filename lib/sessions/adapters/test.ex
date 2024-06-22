defmodule Sessions.CalendarAdapter.Test do
  defstruct [:params]
  
  alias Sessions.Calendar
  alias Sessions.Schedule
  alias Sessions.Session

  @default_minutes 12

  @default_sessions [
    %Session{valve_id: 1, minutes: @default_minutes},
    %Session{valve_id: 2, minutes: @default_minutes},
    %Session{valve_id: 3, minutes: @default_minutes}
  ] 

  def new(adapter) do
    adapter
  end

  defimpl Calendar, for: Test do
    def get_calendar(adapter) do
      # Return a test calendar gonna need a start day
      %Schedule{
        start: NaiveDateTime.add(NaiveDateTime.local_now, -3600, :second),
        sessions: @default_sessions}
    end 
  end 
end
