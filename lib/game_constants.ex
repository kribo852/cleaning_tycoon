
defmodule CleaningTycoon.GameConstants do

#this is called at startup, that is why it is public
  defp get_all_cleaning_prospects() do
    [
     %{name: "Stairwells in an appartment complex", needs: %{vacuuming: 0.2, mopping: 0.7}, payment: 0.5, min_rep_needed: 1},

     %{name: "Street sweeping", needs: %{sweeping: 0.3}, payment: 0.1, min_rep_needed: 0.5},

     %{name: "Hotel", needs: %{vacuuming: 0.3, window_cleaning: 0.2, bed_making: 0.5}, payment: 1.0, min_rep_needed: 6},

     %{name: "School classrooms and corridors", needs: %{vacuuming: 0.2, mopping: 0.4, porcelain_cleaning: 0.2}, payment: 0.35, min_rep_needed: 2},

     %{name: "Bar toilets", needs: %{mopping: 0.3, porcelain_cleaning: 0.3},  payment: 0.5, min_rep_needed: 1}
   ]
  end


  def get_skills() do
    [:vacuuming, :mopping, :sweeping, :window_cleaning, :bed_making, :porcelain_cleaning]
  end

  def get_skills_with_index() do
    get_skills()
    |> Enum.with_index(1)
  end

  def get_standard_filtered_prospects(%{random_value: rv, reputation: rep}) do
    get_all_cleaning_prospects()
    |> Enum.with_index(1)
    |> Enum.filter(fn({prospect, index}) -> prospect.min_rep_needed <= rep or (rem(rv + index, 15) == 0) end)
    |> Enum.map(fn({prospect, index}) -> prospect end)
    |> Enum.with_index(1)
  end

  def get_available_employees_for_hire(%{random_value: rv, reputation: rep}) do
    rv_surname = rv * 11

    first_names = ["Mia", "Victor", "Steven", "Tilda", "Clara", "René", "Wilma"]
    surnames = ["Mop", "Vacuum" , "Sweep", "Tidy", "Clean", "Rinse", "Wash"]

    Enum.map(1..5, fn(index) -> Enum.at(first_names, rem((rv + index * 11), length(first_names))) <> " " <> Enum.at(surnames, rem((rv_surname + index * 11 + 11), length(surnames))) end)
    |> Enum.map(fn(name) -> %Employee{name: name , can_fire: true} end)
    |> Enum.with_index(1)
  end

end