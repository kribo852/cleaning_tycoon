
defmodule CleaningTycoon.GameConstants do

#this is called at startup, that is why it is public
  def get_all_cleaning_prospects() do
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


  def get_all_cleaning_prospects_with_index() do
    get_all_cleaning_prospects()
    |> Enum.with_index(1)
  end

end