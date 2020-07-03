# Functor

![GitHub tag (latest SemVer pre-release)](https://img.shields.io/github/v/tag/kjinho/functor?include_prereleases)

An implementation of functor-style error handling of `:ok`/`:error` tuples.

## Provided Functions

- `f_map`
- `reduce_f_map`
- `is_ok?`
- `is_error?`

## Installation

The package can be installed
by adding `functor` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:functor, git: "https://github.com/kjinho/functor.git", tag: "0.2.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/functor](https://hexdocs.pm/functor).

