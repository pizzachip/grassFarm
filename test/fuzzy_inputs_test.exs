defmodule FuzzyInputsTest do
  use ExUnit.Case
  doctest Fuzzy.Inputs

  alias Fuzzy.Inputs

  test "calculates operator score decay" do
    now = NaiveDateTime.local_now()
    set_date1 = NaiveDateTime.add(now, -12 * 60 * 60, :second)
    IO.inspect(NaiveDateTime.diff(now, set_date1), label: "diff dates")
    assert Inputs.decay_operator_score({100, set_date1, now}) == 50

    set_date2 = NaiveDateTime.add(now, -18 * 60 * 60, :second)
    assert Inputs.decay_operator_score({100, set_date2, now}) == 25 
  end 
end
