# Personal Preferences

- Follow KISS principles.
- Prefer designs aligned with A Philosophy of Software Design.
- Do not modify code before presenting a design and obtaining approval.
- After approval, split work into small, incremental tasks.
- Prefer early returns and guard clauses to keep control flow flat.
  Organize code from high-level intent to implementation details so it
  reads naturally from top to bottom.
- Place public types and primary implementations first, followed by
  private helper functions, with tests at the end. Organize code so
  readers encounter high-level intent before implementation details.
- When using Snafu, prefer with_context over context when constructing
  error context involves formatting, allocation, cloning, or other
  non-trivial work, so it runs only on failure. Use context for cheap
  context selectors.

# Rust

Prefer rtk over direct cargo commands:

```bash
rtk cargo check
rtk cargo test
rtk cargo build
```

If rtk fails, explain the issue and fall back to cargo.

## GreptimeDB SQLness

When running SQLness tests in the GreptimeDB project:

1. If `sqlness-runner` is available in `PATH`, first build the GreptimeDB binary:

   ```bash
   rtk cargo build --bin greptime -p cmd
   ```

   Then run:

   ```bash
   sqlness-runner bare -c ./tests/cases/ -t json -j 4 --bins-dir ./target/debug/
   ```

2. Otherwise, run `make sqlness`, which builds GreptimeDB automatically.
