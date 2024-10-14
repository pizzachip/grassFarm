defmodule GrassFarm.Schedule.SchedulePreferences do
  @type t :: %__MODULE__{
    sunday: %{primary: Time.t(), secondary: Time.t()},
    monday: %{primary: Time.t(), secondary: Time.t()},
    tuesday: %{primary: Time.t(), secondary: Time.t()},
    wednesday: %{primary: Time.t(), secondary: Time.t()},
    thursday: %{primary: Time.t(), secondary: Time.t()},
    friday: %{primary: Time.t(), secondary: Time.t()},
    saturday: %{primary: Time.t(), secondary: Time.t()}
  } 

  defstruct sunday: %{primary: ~T[07:00:00], secondary: ~T[23:00:00]},
    monday: %{primary: ~T[07:00:00], secondary: ~T[23:00:00]},
    tuesday: %{primary: ~T[07:00:00], secondary: ~T[23:00:00]},
    wednesday: %{primary: ~T[07:00:00], secondary: ~T[23:00:00]},
    thursday: %{primary: ~T[07:00:00], secondary: ~T[23:00:00]},
    friday: %{primary: ~T[07:00:00], secondary: ~T[23:00:00]},
    saturday: %{primary: ~T[07:00:00], secondary: ~T[23:00:00]}

end
