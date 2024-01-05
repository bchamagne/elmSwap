module Dex.Function.GetRemoveAmounts exposing (Request, Response, decoder, encoder, run)

import Archethic exposing (..)
import Archethic.Contract exposing (..)
import Dex.State exposing (State)
import Json.Decode as D exposing (Decoder)
import Json.Encode as E exposing (Value)


type alias Request =
    Amount


type alias Response =
    { token1 : Amount, token2 : Amount }


decoder : Decoder Request
decoder =
    D.field "amount" D.float


encoder : Response -> Value
encoder res =
    E.object
        [ ( "token1", E.float res.token1 )
        , ( "token2", E.float res.token2 )
        ]


run : Request -> FunctionContext State -> Result String Response
run args ctx =
    Err "todo"
