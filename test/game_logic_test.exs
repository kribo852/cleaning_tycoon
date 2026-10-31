defmodule GameLogic do
  use ExUnit.Case

  test "get the alternatives for the game choices" do
    choice_tree = CleaningTycoon.GameLogic.chain_choice_options([[%{id: 1, text: "this is the first level"}], [%{id: 2, text: "this is the second level"}]])

    assert List.first(choice_tree).id == 1
  end

  test "get the subchoice for the first game choice" do
    choice_tree = CleaningTycoon.GameLogic.chain_choice_options([[%{id: 1, text: "this is the first level"}], [%{id: 2, text: "this is the second level"}]])

    assert List.first(List.first(choice_tree).subchoices).id == 2
  end

  test "get the subchoice when first choice is not a list" do
    choice_tree = CleaningTycoon.GameLogic.chain_choice_options(%{id: 1, text: "this is the first level"}, [[%{id: 2, text: "this is the second level"}]])

    assert List.first(choice_tree.subchoices).id == 2
  end

end
