defmodule GameConstants do
  use ExUnit.Case

  test "count the number of elements in prospects" do
    assert length(CleaningTycoon.GameConstants.get_standard_filtered_prospects(
      %{random_value: %{actual_for_day: 0, value: 3}, reputation: 10})) == 5
  end

  test "count the number of elements in prospects with lower rep" do
    assert length(CleaningTycoon.GameConstants.get_standard_filtered_prospects(
      %{random_value: %{actual_for_day: 0, value: 3}, reputation: 1.5})) == 3
  end

  test "call the get employees method and get potential employees as a reply" do
    result =  CleaningTycoon.GameConstants.get_available_employees_for_hire(
      %{random_value: %{actual_for_day: 0, value: 1234}, reputation: 1.5})

    assert elem(Enum.at(result, 0), 0).name == "Wilma Sweep"
    assert elem(Enum.at(result, 1), 0).name == "Tilda Wash"
  end

end
