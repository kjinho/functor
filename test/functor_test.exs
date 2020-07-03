defmodule FunctorTest do
  use ExUnit.Case
  doctest Functor

  test "Chain f_map" do
    value = {:ok, [1, 2, 3, 4, 5]}
    assert Functor.f_map(value, &tl/1) |> Functor.f_map(&hd/1) == {:ok, 2}
  end

  test "Error handling" do
    assert Map.fetch(%{}, :a) |> Functor.f_map(&Integer.digits/1) ==
             {:error, "Failed applying function via `Functor.f_map`"}
  end

  test "Success handling" do
    assert Map.fetch(%{a: 1}, :a) |> Functor.f_map(&Integer.digits/1) == {:ok, [1]}
  end

  test "Reduce" do
    value = Integer.digits(123456789) |> Enum.map(&({:ok, &1}))
    assert Functor.reduce_f_map(value, {:ok, 0}, &Kernel.+/2) ==
             {:ok, 45}
    assert Functor.reduce_f_map(value, {:ok, 1}, &Kernel.*/2) ==
             {:ok, 362880}
  end

end
