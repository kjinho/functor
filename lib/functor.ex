defmodule Functor do
  @moduledoc """
  An implementation of functor-style error handling of `:ok`/`:error` tuples.
  """

  @doc """
  fmap implementation for functor for :ok, :error

  ## Examples

      iex> Functor.fmap({:ok, [1, 2, 3]}, &hd/1)
      {:ok, 1}

      iex> Functor.fmap({:error, "This is an error"}, &hd/1)
      {:error, "This is an error"}

      iex> Functor.fmap(:error, &hd/1)
      {:error, "Failed applying function via `fmap`"}
  """
  def fmap(x, f) do
    case x do
      {:ok, value} -> {:ok, f.(value)}
      {:error, value} -> {:error, value}
      _ -> {:error, "Failed applying function via `fmap`"}
    end
  end
  def map_fmap(list, f) do
    Enum.map(list, &(fmap(&1, f)))
  end

  @doc """
  Reduce function applying wrapped values, with a quick escape for any error

  ## Examples

      iex> Functor.reduce_fmap([{:ok, 1}, {:ok, 2}, {:ok, 3}], {:ok, 0}, &+/2)
      {:ok, 6}

      iex> Functor.reduce_fmap([{:ok, 1}, {:ok, 2}, {:error, "Failed"}], {:ok, 0}, &+/2)
      {:error, "Failed"}

      iex> Functor.reduce_fmap([{:ok, 1}, {:ok, 2}, :error], {:ok, 0}, &+/2)
      {:error, "Failed applying function via `reduce_fmap`"}
  """
  def reduce_fmap([], acc, _f) do
    acc
  end
  def reduce_fmap([x|xs], acc, f) do
    case x do
      {:ok, value} -> reduce_fmap(xs, fmap(acc, &(f.(value, &1))), f)
      {:error, value} -> {:error, value}
      _ -> {:error, "Failed applying function via `reduce_fmap`"}
    end
  end
end
