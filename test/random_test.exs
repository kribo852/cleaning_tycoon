defmodule RandomTest do
  use ExUnit.Case

  test "get two different random numbers" do
    result1 = CleaningTycoon.Random.get_random_value_per_day()
    result2 = CleaningTycoon.Random.get_random_value_per_day()

    assert result1 != result2
  end

end