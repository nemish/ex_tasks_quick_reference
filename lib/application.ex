defmodule TestTasks.Application do
  use Application

  def start(_type, _args) do
    children = [
      {TestTasks.Worker, []},
      {Task.Supervisor, name: TestTasks.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: TestTasks.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
