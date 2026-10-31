defmodule RandomTest do
  use ExUnit.Case

  test "get the same value the same day" do

    result = CleaningTycoon.Random.get_random_value_per_day(%{actual_for_day: 1, value: 4}, 1)

    assert result.value == 4
  end

  test "get another value the next" do

    result = CleaningTycoon.Random.get_random_value_per_day(%{actual_for_day: 1, value: 4}, 2)

    assert result.value != 4
  end

end