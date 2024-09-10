defmodule GrassFarm.PersistAdapter.Test do
  defstruct [:set_name, :configs]
  @moduledoc """
    The prod module uses PropertyTable to persist data to a file on the target.
    The format for data set is a little weird, i.e., they are key value pairs, but,
    submitted as a keyword list of strings.  The key is the name of the data set, and the value
    can be any data type.
    This implies that data should be saved in 'sets' but can be lists, maps, etc.
  """
  alias GrassFarm.Persist
  alias GrassFarm.PersistAdapter.Test

  def new(adapter) do
    adapter
  end

  defimpl Persist, for: Test do
    def local_write(_adapter) do
      :ok
    end

    def local_read(adapter) do
      # The functions work better when I am using realistic current times
      # Thus, I'm going to set the watering times that are returned and the wetness score to yesterday at specific times
      zulu = "Etc/UTC"
      
      yesterday = 
        DateTime.utc_now() 
        |> DateTime.add(-1, :day) 
        |> DateTime.to_date 

      evening_watering =
        yesterday
        |> DateTime.new!(~T[16:00:00], zulu) 
        |> DateTime.to_string

      morning_watering =
        yesterday
        |> DateTime.new!(~T[01:00:00], zulu) 
        |> DateTime.to_string

      scoring_time =
        yesterday
        |> DateTime.new!(~T[12:45:23], zulu)

      case adapter.set_name do
        "watering"      -> 
          [
            {evening_watering, 10},
            {morning_watering, 6} 
          ]
        "wetness_score" ->  {scoring_time, -50}
        _           -> []
      end
    end

    # Should not need in Test 
    def save(adapter) do
      adapter.configs
    end

    # Should not need in Test
    def load(adapter) do
      adapter.configs
    end
  end

end
