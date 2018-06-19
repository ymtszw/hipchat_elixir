# Develop and contribute to `hipchat_elixir`

## HipChat API binding modules generation

As written in README.md, API bindings are generated from
[ymtszw/hipchat_swagger](https://github.com/ymtszw/hipchat_swagger).

The following rules apply:

- Treat each API's:
    - `summary` as identifiers (i.e. source of function names), with lower-casing and underscoring.
    - `description` as `@doc` contents, though expecting only links to official API docs.
    - `tags` as API categories, with camel-casing.
      They are used for separating modules (files). **Expecting only one tag per API**.
- Basically discarding parameters' schema/type information, at least currently.
- Response information are discarded too.

So when you implement yet-to-be-covered HipChat API bindings in `hipchat_elixir`:

1. Write swagger specs for those APIs in [ymtszw/hipchat_swagger](https://github.com/ymtszw/hipchat_swagger)
2. When merged, update git submodule in this repository (`git submodule foreach "git pull origin master"`)
3. Generate modules/functions with `mix hipchat.generate`
4. Run tests with `mix test`
    - Test cases are automatically generated
    - If you happen to have actual `access_token` (preferably in dummy hipchat team),
      run with `HIPCHAT_ACCESS_TOKEN=<your_token> mix test`

Then send a pull request!
