let Text/concatMapSep =
      https://prelude.dhall-lang.org/v23.1.0/Text/concatMapSep.dhall
        sha256:c272aca80a607bc5963d1fcb38819e7e0d3e72ac4d02b1183b1afb6a91340840

let NameValuePair = { name : Text, value : Text }

let Option =
      < Plain : Text | Compound : NameValuePair | AddModule : NameValuePair >

let renderEnv = \(var : NameValuePair) -> var.name ++ "='" ++ var.value ++ "'"

let renderOption =
      \(path : Text) ->
      \(opt : Option) ->
        let longOpt = "--"

        in  merge
              { Plain = \(popt : Text) -> longOpt ++ popt
              , Compound =
                  \(copt : NameValuePair) ->
                    longOpt ++ copt.name ++ "='" ++ copt.value ++ "'"
              , AddModule =
                  \(mopt : NameValuePair) ->
                    let modulePath = path ++ "/" ++ mopt.value

                    in  longOpt ++ mopt.name ++ "='" ++ modulePath ++ "'"
              }
              opt

let vars =
      let enableVar = \(name : Text) -> { name, value = "yes" }

      in  Text/concatMapSep
            " "
            NameValuePair
            renderEnv
            [ enableVar "NGX_HTTP_CUSTOM_COUNTERS_PERSISTENCY"
            , enableVar
                "NGX_HTTP_COMBINED_UPSTREAMS_PERSISTENT_UPSTRAND_INTERCEPT_CTX"
            ]

let opts =
      \(path : Text) ->
        let addModule =
              \(value : Text) -> Option.AddModule { name = "add-module", value }

        let addDynModule =
              \(value : Text) ->
                Option.AddModule { name = "add-dynamic-module", value }

        in  Text/concatMapSep
              " "
              Option
              (renderOption path)
              [ Option.Plain "with-http_ssl_module"
              , Option.Plain "with-http_stub_status_module"
              , addModule "echo-nginx-module"
              , addModule "nginx-custom-counters-module"
              , addModule "nginx-easy-context"
              , addModule "nginx-combined-upstreams-module"
              , addModule "nginx-haskell-module"
              , addModule "nginx-haskell-module/aliases"
              , addModule
                  "nginx-haskell-module/examples/dynamicUpstreams/nginx-upconf-module"
              , addDynModule "nginx-healthcheck-plugin"
              , addDynModule "nginx-log-plugin"
              , addDynModule "nginx-log-plugin/module"
              , addModule "nginx-proxy-peer-host"
              ]

in  { vars, opts, all = \(path : Text) -> { vars, opts = opts path } }
