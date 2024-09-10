defmodule PersistTest do
  use ExUnit.Case
  doctest GrassFarm.PersistAdapter

  alias GrassFarm.PersistAdapter

  test "create a new persist adapter returns struct" do
    
    assert PersistAdapter.new(%{set_name: "watering", configs: %{}}) ==
      %GrassFarm.PersistAdapter.Test{set_name: "watering", configs: %{}}
  end

end
