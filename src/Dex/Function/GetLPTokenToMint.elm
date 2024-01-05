module Dex.Function.GetLPTokenToMint exposing (Request, Response, decoder, encoder, run)

import Archethic exposing (..)
import Archethic.Contract exposing (..)
import Dex.Helpers exposing (getLPTokenToMint)
import Dex.State exposing (State)
import Json.Decode as D exposing (Decoder)
import Json.Encode as E exposing (Value)


type alias Request =
    { token1 : Amount
    , token2 : Amount
    }


type alias Response =
    Amount


decoder : Decoder Request
decoder =
    D.map2 Request
        (D.field "token1_amount" D.float)
        (D.field "token2_amount" D.float)


encoder : Response -> Value
encoder res =
    E.float res


run : Request -> FunctionContext State -> Result String Response
run args ctx =
    Ok <| getLPTokenToMint ( args.token1, args.token2 ) ctx.state
