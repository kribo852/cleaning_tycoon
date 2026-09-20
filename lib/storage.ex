defmodule Storage do
  use GenServer

  # --- Client API ---
  # Dessa funktioner anropas från andra moduler
  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def get_data do
    GenServer.call(__MODULE__, :get_data)
  end

  def welcome do
    GenServer.call(__MODULE__, :welcome)
  end

  def get_menu_choices(tmp_frontend_memory) do
    GenServer.call(__MODULE__, {:get_menu_choices, tmp_frontend_memory})
  end

  # --- Server Callbacks ---
  @impl true
  def init(initial_state) do
    {:ok, initial_state}
  end

  @impl true
  def handle_call(:get_data, _from, state) do
    {:reply, "money: #{state.money}, reputation: #{state.reputation}", state}
  end

  @impl true
  def handle_call(:welcome, _from, state) do
    {:reply, "Welcome to Cleaning Tycoon", state}
  end

  @impl true
  def handle_call({:get_menu_choices, tmp_frontend_memory}, _from, state) do
    {new_state, choices, new_tmp_frontend_memory} = CleaningTycoon.GameLogic.get_menu_choices(state, tmp_frontend_memory)


    {:reply, {choices, new_tmp_frontend_memory} , new_state}
  end

end