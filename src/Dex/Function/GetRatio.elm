module Dex.Function.GetRatio exposing (Request, Response, decoder, encoder, run)

import Archethic exposing (..)
import Archethic.Contract exposing (..)
import Dex.State exposing (State)
import Json.Decode as D exposing (Decoder)
import Json.Encode as E exposing (Value)


type alias Request =
    TransactionAddress


type alias Response =
    Amount


decoder : Decoder Request
decoder =
    D.field "token_address" D.string


encoder : Response -> Value
encoder res =
    E.float res


run : Request -> FunctionContext State -> Result String Response
run tokenAddress ctx =
    let
        ( token1Reserve, token2Reserve ) =
            ctx.state.reserves
    in
    if token1Reserve > 0 && token2Reserve > 0 then
        if tokenAddress == "TOKEN_ADDRESS" then
            Ok (token2Reserve / token1Reserve)

        else
            Ok (token1Reserve / token2Reserve)

    else
        Ok 0.0
