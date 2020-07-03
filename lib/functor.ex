defmodule Functor do
  @moduledoc """
  An implementation of functor-style error handling of `:ok`/`:error` tuples.
  """

  @type result() :: {:ok, any()} | {:error, any()} | :error

  @doc """
  map implementation for functor for :ok, :error

  ## Examples

      iex> Functor.f_map({:ok, [1, 2, 3]}, &hd/1)
      {:ok, 1}

      iex> Functor.f_map({:error, "This is an error"}, &hd/1)
      {:error, "This is an error"}

      iex> Functor.f_map(:error, &hd/1)
      {:error, "Failed applying function via `Functor.f_map`"}

      iex> Functor.f_map({:ok, [1, 2, 3]}, &hd/1)
      ...> |> Functor.f_map(&(10 + &1))
      {:ok, 11}
  """
  @spec f_map(result(),(any()->any())) :: result()
  def f_map(x, f) do
    case x do
      {:ok, value} -> {:ok, f.(value)}
      {:error, value} -> {:error, value}
      _ -> {:error, "Failed applying function via `Functor.f_map`"}
    end
  end

  @doc """
  Reduce function applying wrapped values, with a quick escape for any error

  ## Examples

      iex> Functor.reduce_f_map([{:ok, 1}, {:ok, 2}, {:ok, 3}], {:ok, 0}, &+/2)
      {:ok, 6}

      iex> Functor.reduce_f_map([{:ok, 1}, {:ok, 2}, {:error, "Failed"}], {:ok, 0}, &+/2)
      {:error, "Failed"}

      iex> Functor.reduce_f_map([{:ok, 1}, {:ok, 2}, :error], {:ok, 0}, &+/2)
      {:error, "Failed applying function via `Functor.reduce_map`"}
  """
  @spec reduce_f_map([result()], any(), (any(), any() -> any())) :: result()
  def reduce_f_map([], acc, _f) do
    acc
  end
  def reduce_f_map([x|xs], acc, f) do
    case x do
      {:ok, value} -> reduce_f_map(xs, f_map(acc, &(f.(value, &1))), f)
      {:error, value} -> {:error, value}
      _ -> {:error, "Failed applying function via `Functor.reduce_map`"}
    end
  end

  @doc """
  Tests for whether a result is `:ok`

  ## Examples

      iex> Functor.is_ok?({:ok, 12})
      true

      iex> Functor.is_ok?(12)
      false

      iex> Functor.is_ok?(:error)
      false

      iex> Functor.is_ok?({:error, "This is an error."})
      false
  """
  @spec is_ok?(result()) :: boolean()
  def is_ok?({:ok, _}), do: true
  def is_ok?(_), do: false

  @doc """
  Tests for whether a result is not `:ok`

  ## Examples

      iex> Functor.is_error?({:ok, 12})
      false

      iex> Functor.is_error?(12)
      true

      iex> Functor.is_error?(:error)
      true

      iex> Functor.is_error?({:error, "This is an error."})
      true
  """
  @spec is_error?(result()) :: boolean()
  def is_error?({:ok, _}), do: false
  def is_error?(_), do: true
end
