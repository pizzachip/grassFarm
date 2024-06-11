defmodule Sessions.Schedule  do

  @type t:: %__MODULE__{
    start: Time.t(),
    sessions: [Sessions.Session.t()]
  }
  defstruct [:start, sessions: []]

end
