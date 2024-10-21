defmodule TestTasks.Worker do
  use GenServer
  # Client API

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  # Server Callbacks

  def init(_opts) do
    # Initialize with some state
    {:ok, %{tasks: %{}}}
  end

  def handle_call({:run_task, arg}, _from, state) do
    task = Task.async(fn -> TestTasks.expensive_operation(arg) end)
    result = Task.await(task)
    IO.puts("result #{inspect(result)}")
    {:reply, state, state}
  end

  def handle_call({:schedule_task, arg}, _from, state) do
    task =
      Task.Supervisor.async_nolink(TestTasks.TaskSupervisor, fn ->
        TestTasks.expensive_operation(arg)
      end)

    state = put_in(state.tasks[task.ref], arg)
    {:reply, state, state}
  end

  def run_task(arg) do
    GenServer.call(__MODULE__, {:run_task, arg})
  end

  def schedule_task(arg) do
    GenServer.call(__MODULE__, {:schedule_task, arg})
  end

  # If the task succeeds...
  def handle_info({ref, result}, state) do
    # The task succeed so we can cancel the monitoring and discard the DOWN message
    Process.demonitor(ref, [:flush])

    {arg, state} = pop_in(state.tasks[ref])
    IO.puts("Got #{inspect(result)} for arg #{inspect(arg)}")
    {:noreply, state}
  end

  # If the task fails...
  def handle_info({:DOWN, ref, _, _, reason}, state) do
    {arg, state} = pop_in(state.tasks[ref])
    IO.puts("Arg #{inspect(arg)} failed with reason #{inspect(reason)}")
    {:noreply, state}
  end
end
