defmodule PersistTest do
  use ExUnit.Case
  doctest Persist.PersistAdapter

  alias Persist.PersistAdapter

  test "create a new persist adapter returns struct" do
    
    assert PersistAdapter.new(%{set_name: "watering", configs: %{}}) ==
      %Persist.PersistAdapter.Test{set_name: "watering", configs: %{}}
  end

end
