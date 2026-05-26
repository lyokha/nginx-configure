let Text/concatMapSep =
      https://prelude.dhall-lang.org/v23.1.0/Text/concatMapSep.dhall
        sha256:c272aca80a607bc5963d1fcb38819e7e0d3e72ac4d02b1183b1afb6a91340840

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
      Text/concatMapSep
        " "
        Text
        (renderEnv "yes")
        [ "NGX_HTTP_CUSTOM_COUNTERS_PERSISTENCY"
        , "NGX_HTTP_COMBINED_UPSTREAMS_PERSISTENT_UPSTRAND_INTERCEPT_CTX"
        ]

let opts =
      \(path : Text) ->
        let addModule = "add-module"

        let addDynModule = "add-dynamic-module"

        in  Text/concatMapSep
              " "
              Option
              (renderOption path)
              [ Option.Plain { value = "with-http_ssl_module" }
              , Option.Plain { value = "with-http_stub_status_module" }
              , Option.Compound { key = addModule, value = "echo-nginx-module" }
              , Option.Compound
                  { key = addModule, value = "nginx-custom-counters-module" }
              , Option.Compound
                  { key = addModule, value = "nginx-easy-context" }
              , Option.Compound
                  { key = addModule, value = "nginx-combined-upstreams-module" }
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

in  { vars, opts, all = \(path : Text) -> { vars, opts = opts path } }
