module Dex.Function.GetPoolInfos exposing (Response, encoder, run)

import Archethic exposing (..)
import Archethic.Contract exposing (..)
import Dex.State exposing (State)
import Json.Encode as E exposing (Value)


type alias PoolInfo =
    { address : TransactionAddress
    , reserve : Amount
    }


type alias LPInfo =
    { address : TransactionAddress
    , supply : Amount
    }


type alias Response =
    { token1 : PoolInfo
    , token2 : PoolInfo
    , lpToken : LPInfo
    , fee : Amount
    }


encoder : Response -> Value
encoder res =
    E.object
        [ ( "token1"
          , E.object
                [ ( "address", E.string res.token1.address )
                , ( "reserve", E.float res.token1.reserve )
                ]
          )
        , ( "token2"
          , E.object
                [ ( "address", E.string res.token2.address )
                , ( "reserve", E.float res.token2.reserve )
                ]
          )
        , ( "lp_token"
          , E.object
                [ ( "address", E.string res.lpToken.address )
                , ( "supply", E.float res.lpToken.supply )
                ]
          )
        , ( "fee", E.float res.fee )
        ]


run : FunctionContext State -> Result String Response
run ctx =
    Err "todo"
