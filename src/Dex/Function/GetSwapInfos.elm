module Dex.Function.GetSwapInfos exposing (Request, Response, decoder, encoder, run)

import Archethic exposing (..)
import Archethic.Contract exposing (..)
import Dex.State exposing (State)
import Json.Decode as D exposing (Decoder)
import Json.Encode as E exposing (Value)


type alias Request =
    { tokenAddress : TransactionAddress
    , amount : Amount
    }


type alias Response =
    { outputAmount : Amount
    , fee : Amount
    , priceImpact : Amount
    }


decoder : Decoder Request
decoder =
    D.map2 Request
        (D.field "token_address" D.string)
        (D.field "amount" D.float)


encoder : Response -> Value
encoder res =
    E.object
        [ ( "output_amount", E.float res.outputAmount )
        , ( "fee", E.float res.fee )
        , ( "price_impact", E.float res.priceImpact )
        ]


run : Request -> FunctionContext State -> Result String Response
run args ctx =
    Err "todo"
