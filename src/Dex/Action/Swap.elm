module Dex.Action.Swap exposing (action, condition, decoder)

import Archethic exposing (..)
import Archethic.Contract exposing (..)
import Dex.State exposing (State)
import Json.Decode as D exposing (Decoder)


decoder : Decoder Amount
decoder =
    D.field "amount" D.float


condition : Amount -> TransactionTriggerContext State -> Result String Bool
condition amount context =
    Ok True


action : Amount -> TransactionTriggerContext State -> Result String ( Maybe State, Maybe Transaction )
action amount context =
    Ok ( Nothing, Nothing )
