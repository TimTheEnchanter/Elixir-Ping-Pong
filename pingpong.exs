defmodule PingPong do
  def ready do
    receive do
      {sender, action, 11} ->
        IO.puts("#{11} from #{inspect(sender)}, sent #{inspect(action)}")
        IO.puts("Game Over")
        ready

      {sender, action, turn} ->
        hit_to(sender, switch(action), turn + 1)
        ready
    after
      1_000 -> IO.puts("Timing out #{inspect(player_pid)}")
    end
  end

  def hit_to(opponent_id, action, turn) do
    IO.puts("#{turn}. hit_to #{inspect(opponent_id)} #{inspect(action)}")
    send(opponent_id, {player_pid, action, turn})
  end

  defp switch(action) do
    case action do
      :ping -> :pong
      _____ -> :ping
    end
  end

  defp player_pid do
    self
  end
end

player_1 = self
player_2 = spawn(PingPong, :ready, [])

IO.puts("player_1: #{inspect(player_1)}")
IO.puts("player_2: #{inspect(player_2)}")

PingPong.hit_to(player_2, :ping, 1)

PingPong.ready()
