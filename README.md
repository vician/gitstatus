# Gitstatus

## Usage

```
./gitstatus.sh GIT_ROOT [VERBOSITY=2] [FETCH=0]
```

## Verbosity

- 0: Only exit code (number of exit code means count of unhandled actions)
- 1: Exit code with brief decription on stdout (e.q.: "Git: 3)
- 2: Exit code with better description on stdout (e.q.: "??: 3, M: 2")
- 3: Short stdout
- 4: Standard output (print all repositories)
- 5: Debug

## TODO

- Argument parser
- Parse `git status -sb`
