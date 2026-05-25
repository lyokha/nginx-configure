I often configure Nginx builds on different machines with many custom modules.
Adding modules is only available via command-line options `--add-module` or
`--add-dynamic-module` in script `./configure`. That's why this is so difficult
to achieve reproducible builds everywhere I build Nginx. Here is a very simple
approach to struggle with this difficulty.

#### Requirements

- [*dhall-to-bash*](https://github.com/dhall-lang/dhall-haskell/tree/main/dhall-bash)
  executable file. [*Dhall*](https://dhall-lang.org/) is a typed configuration
  language on steroids. Script *ngx_configure.dhall* contains all Nginx
  configuration options needed.
- Sources of the custom modules must have been put in a single directory, say
  `$HOME/devel`, before building Nginx. Absence or unsatisfied dependencies of a
  module will make `./configure` fail.

#### Configure and build Nginx

- Put *ngx_configure.sh* in the directory with Nginx sources.
- Run `./ngx_configure.sh $HOME/devel` from that directory.
- If the configuration was successful, run `make`.

#### Cache Nginx configuration options

Run `dhall hash --cache --file ngx_configure.dhall` if you want to cache the
configuration functions for future runs of `./ngx_configure.sh`.
