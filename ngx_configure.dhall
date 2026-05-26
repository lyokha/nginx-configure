let Text/concatMapSep =
      https://prelude.dhall-lang.org/v23.1.0/Text/concatMapSep.dhall
        sha256:c272aca80a607bc5963d1fcb38819e7e0d3e72ac4d02b1183b1afb6a91340840

let NameValuePair = { name : Text, value : Text }

let Option = < Plain : Text | Compound : NameValuePair >

let renderEnv =
      \(cenv : NameValuePair) -> cenv.name ++ "='" ++ cenv.value ++ "'"

let renderOption =
      \(path : Text) ->
      \(opt : Option) ->
        let longOpt = "--"

        in  merge
              { Plain = \(popt : Text) -> longOpt ++ popt
              , Compound =
                  \(copt : NameValuePair) ->
                    let modulePath = path ++ "/" ++ copt.value

                    in  longOpt ++ copt.name ++ "='" ++ modulePath ++ "'"
              }
              opt

let vars =
      let yes = "yes"

      in  Text/concatMapSep
            " "
            NameValuePair
            renderEnv
            [ { name = "NGX_HTTP_CUSTOM_COUNTERS_PERSISTENCY", value = yes }
            , { name =
                  "NGX_HTTP_COMBINED_UPSTREAMS_PERSISTENT_UPSTRAND_INTERCEPT_CTX"
              , value = yes
              }
            ]

let opts =
      \(path : Text) ->
        let addModule = "add-module"

        let addDynModule = "add-dynamic-module"

        in  Text/concatMapSep
              " "
              Option
              (renderOption path)
              [ Option.Plain "with-http_ssl_module"
              , Option.Plain "with-http_stub_status_module"
              , Option.Compound
                  { name = addModule, value = "echo-nginx-module" }
              , Option.Compound
                  { name = addModule, value = "nginx-custom-counters-module" }
              , Option.Compound
                  { name = addModule, value = "nginx-easy-context" }
              , Option.Compound
                  { name = addModule
                  , value = "nginx-combined-upstreams-module"
                  }
              , Option.Compound
                  { name = addModule, value = "nginx-haskell-module" }
              , Option.Compound
                  { name = addModule, value = "nginx-haskell-module/aliases" }
              , Option.Compound
                  { name = addModule
                  , value =
                      "nginx-haskell-module/examples/dynamicUpstreams/nginx-upconf-module"
                  }
              , Option.Compound
                  { name = addDynModule, value = "nginx-healthcheck-plugin" }
              , Option.Compound
                  { name = addDynModule, value = "nginx-log-plugin" }
              , Option.Compound
                  { name = addDynModule, value = "nginx-log-plugin/module" }
              , Option.Compound
                  { name = addModule, value = "nginx-proxy-peer-host" }
              ]

in  { vars, opts, all = \(path : Text) -> { vars, opts = opts path } }
