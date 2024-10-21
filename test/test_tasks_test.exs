defmodule TestTasksTest do
  use ExUnit.Case
  doctest TestTasks

  test "greets the world" do
    assert TestTasks.hello() == :world
  end
end
