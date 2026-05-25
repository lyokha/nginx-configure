let Text/concatSep =
      https://prelude.dhall-lang.org/v23.1.0/Text/concatSep
        sha256:e4401d69918c61b92a4c0288f7d60a6560ca99726138ed8ebc58dca2cd205e58

let srcModulePath = env:SRC_MODULE_PATH as Text ? "."

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

let toAbsPath = \(path : Text) -> srcModulePath ++ "/" ++ path

let toEnv = \(var : Text) -> var ++ "=" ++ "yes"

let vars =
      Text/concatSep
        " "
        [ toEnv "NGX_HTTP_CUSTOM_COUNTERS_PERSISTENCY"
        , toEnv "NGX_HTTP_COMBINED_UPSTREAMS_PERSISTENT_UPSTRAND_INTERCEPT_CTX"
        ]

let opts =
      Text/concatSep
        " "
        [ toText (Option.Plain { value = "with-http_ssl_module" })
        , toText (Option.Plain { value = "with-http_stub_status_module" })
        , toText
            ( Option.Compound
                { key = addModule, value = toAbsPath "echo-nginx-module" }
            )
        , toText
            ( Option.Compound
                { key = addModule
                , value = toAbsPath "nginx-custom-counters-module"
                }
            )
        , toText
            ( Option.Compound
                { key = addModule, value = toAbsPath "nginx-easy-context" }
            )
        , toText
            ( Option.Compound
                { key = addModule
                , value = toAbsPath "nginx-combined-upstreams-module"
                }
            )
        , toText
            ( Option.Compound
                { key = addModule, value = toAbsPath "nginx-haskell-module" }
            )
        , toText
            ( Option.Compound
                { key = addModule
                , value = toAbsPath "nginx-haskell-module/aliases"
                }
            )
        , toText
            ( Option.Compound
                { key = addModule
                , value =
                    toAbsPath
                      "nginx-haskell-module/examples/dynamicUpstreams/nginx-upconf-module"
                }
            )
        , toText
            ( Option.Compound
                { key = addDynModule
                , value = toAbsPath "nginx-healthcheck-plugin"
                }
            )
        , toText
            ( Option.Compound
                { key = addDynModule, value = toAbsPath "nginx-log-plugin" }
            )
        , toText
            ( Option.Compound
                { key = addDynModule
                , value = toAbsPath "nginx-log-plugin/module"
                }
            )
        , toText
            ( Option.Compound
                { key = addModule, value = toAbsPath "nginx-proxy-peer-host" }
            )
        ]

in  { vars, opts, all = { vars, opts } }
