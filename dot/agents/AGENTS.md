# Personal Preferences

- Follow KISS principles.
- Prefer designs aligned with A Philosophy of Software Design.
- Do not modify code before presenting a design and obtaining approval.
- After approval, split work into small, incremental tasks.

# Documentation

- For external libraries and frameworks, prefer Context7 documentation over
  model knowledge.
- Use Context7 whenever API details, examples, or version-specific behavior
  may matter.
- If Context7 is unavailable or lacks relevant information, state that 
  explicitly and fall back to other sources.

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
