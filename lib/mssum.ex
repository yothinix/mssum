defmodule Mssum do
  def main do
    issue = %{
      :id => 1,
      :name => "Some issue name"
    }

    IO.puts issue[:name]

  end
end
