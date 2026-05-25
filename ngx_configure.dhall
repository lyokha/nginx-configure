let Text/concatSep =
      https://prelude.dhall-lang.org/v23.1.0/Text/concatSep
        sha256:e4401d69918c61b92a4c0288f7d60a6560ca99726138ed8ebc58dca2cd205e58

let List/map =
      https://prelude.dhall-lang.org/v23.1.0/List/map
        sha256:dd845ffb4568d40327f2a817eb42d1c6138b929ca758d50bc33112ef3c885680

let addModule
    : Text
    = "add-module"

let addDynModule
    : Text
    = "add-dynamic-module"

let Option =
      < Plain : { value : Text } | Compound : { key : Text, value : Text } >

let toText =
      \(opt : Option) ->
        merge
          { Plain = \(popt : { value : Text }) -> "--" ++ popt.value
          , Compound =
              \(copt : { key : Text, value : Text }) ->
                "--" ++ copt.key ++ "='" ++ copt.value ++ "'"
          }
          opt

let toModulePath = \(path : Text) -> \(module : Text) -> path ++ "/" ++ module

let toEnv = \(var : Text) -> var ++ "=" ++ "yes"

let vars =
      Text/concatSep
        " "
        [ toEnv "NGX_HTTP_CUSTOM_COUNTERS_PERSISTENCY"
        , toEnv "NGX_HTTP_COMBINED_UPSTREAMS_PERSISTENT_UPSTRAND_INTERCEPT_CTX"
        ]

let opts =
      \(path : Text) ->
        let textOpts =
              List/map
                Option
                Text
                toText
                [ Option.Plain { value = "with-http_ssl_module" }
                , Option.Plain { value = "with-http_stub_status_module" }
                , Option.Compound
                    { key = addModule
                    , value = toModulePath path "echo-nginx-module"
                    }
                , Option.Compound
                    { key = addModule
                    , value = toModulePath path "nginx-custom-counters-module"
                    }
                , Option.Compound
                    { key = addModule
                    , value = toModulePath path "nginx-easy-context"
                    }
                , Option.Compound
                    { key = addModule
                    , value =
                        toModulePath path "nginx-combined-upstreams-module"
                    }
                , Option.Compound
                    { key = addModule
                    , value = toModulePath path "nginx-haskell-module"
                    }
                , Option.Compound
                    { key = addModule
                    , value = toModulePath path "nginx-haskell-module/aliases"
                    }
                , Option.Compound
                    { key = addModule
                    , value =
                        toModulePath
                          path
                          "nginx-haskell-module/examples/dynamicUpstreams/nginx-upconf-module"
                    }
                , Option.Compound
                    { key = addDynModule
                    , value = toModulePath path "nginx-healthcheck-plugin"
                    }
                , Option.Compound
                    { key = addDynModule
                    , value = toModulePath path "nginx-log-plugin"
                    }
                , Option.Compound
                    { key = addDynModule
                    , value = toModulePath path "nginx-log-plugin/module"
                    }
                , Option.Compound
                    { key = addModule
                    , value = toModulePath path "nginx-proxy-peer-host"
                    }
                ]

        in  Text/concatSep " " textOpts

let all = \(path : Text) -> { vars, opts = opts path }

in  { vars, opts, all }
