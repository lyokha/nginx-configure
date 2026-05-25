let Text/concatSep =
      https://prelude.dhall-lang.org/v23.1.0/Text/concatSep.dhall
        sha256:e4401d69918c61b92a4c0288f7d60a6560ca99726138ed8ebc58dca2cd205e58

let List/map =
      https://prelude.dhall-lang.org/v23.1.0/List/map.dhall
        sha256:dd845ffb4568d40327f2a817eb42d1c6138b929ca758d50bc33112ef3c885680

let Option =
      < Plain : { value : Text } | Compound : { key : Text, value : Text } >

let renderEnv = \(value : Text) -> \(var : Text) -> var ++ "=" ++ value

let renderOption =
      \(path : Text) ->
      \(opt : Option) ->
        let longOpt = "--"

        in  merge
              { Plain = \(popt : { value : Text }) -> longOpt ++ popt.value
              , Compound =
                  \(copt : { key : Text, value : Text }) ->
                    let modulePath = path ++ "/" ++ copt.value

                    in  longOpt ++ copt.key ++ "='" ++ modulePath ++ "'"
              }
              opt

let vars =
      let envList =
            List/map
              Text
              Text
              (renderEnv "yes")
              [ "NGX_HTTP_CUSTOM_COUNTERS_PERSISTENCY"
              , "NGX_HTTP_COMBINED_UPSTREAMS_PERSISTENT_UPSTRAND_INTERCEPT_CTX"
              ]

      in  Text/concatSep " " envList

let opts =
      \(path : Text) ->
        let addModule = "add-module"

        let addDynModule = "add-dynamic-module"

        let textOpts =
              List/map
                Option
                Text
                (renderOption path)
                [ Option.Plain { value = "with-http_ssl_module" }
                , Option.Plain { value = "with-http_stub_status_module" }
                , Option.Compound
                    { key = addModule, value = "echo-nginx-module" }
                , Option.Compound
                    { key = addModule, value = "nginx-custom-counters-module" }
                , Option.Compound
                    { key = addModule, value = "nginx-easy-context" }
                , Option.Compound
                    { key = addModule
                    , value = "nginx-combined-upstreams-module"
                    }
                , Option.Compound
                    { key = addModule, value = "nginx-haskell-module" }
                , Option.Compound
                    { key = addModule, value = "nginx-haskell-module/aliases" }
                , Option.Compound
                    { key = addModule
                    , value =
                        "nginx-haskell-module/examples/dynamicUpstreams/nginx-upconf-module"
                    }
                , Option.Compound
                    { key = addDynModule, value = "nginx-healthcheck-plugin" }
                , Option.Compound
                    { key = addDynModule, value = "nginx-log-plugin" }
                , Option.Compound
                    { key = addDynModule, value = "nginx-log-plugin/module" }
                , Option.Compound
                    { key = addModule, value = "nginx-proxy-peer-host" }
                ]

        in  Text/concatSep " " textOpts

in  { vars, opts, all = \(path : Text) -> { vars, opts = opts path } }
