I often configure Nginx builds on different machines with many custom modules.
Adding modules is only available via command-line options `--add-module` or
`--add-dynamic-module` in script `./configure`. That's why this is so difficult
to achieve reproducible builds everywhere I build Nginx. Here is a very simple
approach to struggle with this difficulty.

#### Requirements

- [*dhall-to-bash*](https://github.com/dhall-lang/dhall-haskell/tree/main/dhall-bash)
  executable file. [*Dhall*](https://dhall-lang.org/) is a typed programmable
  configuration language. Script *ngx_configure.dhall* contains all Nginx
  configuration options needed.
- Sources of the custom modules listed in *ngx_configure.dhall* must have been
  put in a single directory, say `$HOME/devel`, before building Nginx. Absence
  or unsatisfied dependencies of a module will make `./configure` fail.

#### Configure and build Nginx

- Put *ngx_configure.sh* in a directory listed in `$PATH`.
- Run `ngx_configure.sh $HOME/devel` from the directory with Nginx sources.
- If the configuration was successful, run `make`.
