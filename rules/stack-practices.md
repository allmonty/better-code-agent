# Stack practices

- Identify the stack from its manifests (`package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `mix.exs`, `pom.xml`, `Gemfile`, ...) and the versions in the lockfile.
- Use the stack's standard tools, already installed ones first:

| Stack | Format | Lint / types | Test | E2E |
|---|---|---|---|---|
| TypeScript / JS | prettier or biome | eslint, `tsc --noEmit` (strict) | vitest or jest | Playwright |
| Python | ruff format | ruff, mypy or pyright | pytest | Playwright |
| Go | gofmt | go vet, golangci-lint | go test | - |
| Rust | rustfmt | clippy | cargo test | - |
| Elixir | mix format | credo, dialyzer | ExUnit | Wallaby / Playwright |
| Java / Kotlin | spotless | compiler warnings as errors, detekt | JUnit | Playwright |
| Ruby | rubocop | rubocop, sorbet | rspec or minitest | Capybara |

- Wire format check, lint, type check, and tests into `scripts/check.sh`. That one command is the definition of green.
- Add two cheap sensors that agents need more than humans: a duplication check (e.g. jscpd, any language) and a complexity limit in the linter (eslint `complexity`, ruff `C901`, gocyclo, clippy `cognitive_complexity`, credo). AI-assisted code measurably grows in both.
- Use the framework's idioms for the version you're on. Before calling an API you're unsure of, check the installed version's docs or source; APIs change between versions.
- Fix warnings rather than suppress them. Keep the strictest settings the project already uses.
