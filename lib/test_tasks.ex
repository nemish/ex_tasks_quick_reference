defmodule TestTasks do
  @moduledoc """
  Documentation for `TestTasks`.
  """

  Import

  @doc """
  Hello world.

  ## Examples

      iex> TestTasks.hello()
      :world

  """
  def hello do
    task =
      Task.async(fn -> expensive_operation(1) end)

    res = task |> Task.await()
    IO.puts("res #{inspect(res)}")
  end

  def expensive_operation(arg) do
    IO.puts("Expensive operation for arg #{arg} start: #{inspect(DateTime.utc_now())}")
    :timer.sleep(3000)
    IO.puts("Expensive operation for arg #{arg} stop: #{inspect(DateTime.utc_now())}")
    arg + 2
  end

  def run do
    TestTasks.Worker.run_task(1)
    TestTasks.Worker.run_task(2)
  end

  def schedule do
    TestTasks.Worker.schedule_task(3)
    TestTasks.Worker.schedule_task(4)
  end
end
