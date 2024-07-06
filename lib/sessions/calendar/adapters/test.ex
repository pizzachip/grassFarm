defmodule Sessions.CalendarAdapter.Test do
  defstruct [:params]
  
  alias Sessions.Calendar
  alias Sessions.Schedule
  alias Sessions.Session

  def new(adapter) do
    adapter
  end

  defimpl Calendar, for: Test do
    def get_calendar(_adapter) do
      # Return a test calendar gonna need a start day
      %Schedule{
        start: NaiveDateTime.add(NaiveDateTime.local_now, -3600, :second),
        sessions: [
          %Session{valve_id: 1, minutes: 12},
          %Session{valve_id: 2, minutes: 12},
          %Session{valve_id: 3, minutes: 12}
        ]      
      }
    end 

    def update_calendar(adapter) do
      adapter
    end 

    def save_calendar(adapter) do
      adapter
    end 
  end 
end
