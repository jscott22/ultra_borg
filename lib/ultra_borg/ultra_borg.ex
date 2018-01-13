defmodule UltraBorg do

  use GenServer

  alias UltraBorg.{Sensors, Detection}
  
  defmodule State do
    defstruct bus_number: nil, i2c_address: nil, found_chip: false
  end

  def start_link(%{bus_number: bus_number, i2c_address: i2c_address}) do
    IO.puts("starting")
    GenServer.start_link(__MODULE__, %State{bus_number: bus_number, i2c_address: i2c_address}, name: __MODULE__)
  end

  def init(state) do
    IO.puts("Loading UltraBorg on bus #{state.bus_number}, address #{state.i2c_address}")

    found_chip = init_borg(state.i2c_address)

    {:ok, %State{state | found_chip: found_chip}}
  end

   ### CLIENT

  def debug() do
    GenServer.call(__MODULE__, :debug)
    |> IO.inspect()
  end

  def read_sensors() do
    GenServer.call(__MODULE__, :read_sensors)
  end

  ### SERVER

  def handle_call(:debug, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:read_sensors, _from, state) do
    Sensors.read_sensors()
    |> IO.inspect()
    {:reply, state, state}
  end

  def handle_info(msg, _state) do
    IO.inspect(msg)
  end

  ### INIT

  defp init_borg(i2c_address) do
    Detection.find_borg(i2c_address)
  end

end