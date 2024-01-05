module Dex.Action.RemoveLiquidity exposing (action, condition)

import Archethic exposing (..)
import Archethic.Contract exposing (..)
import Dex.State exposing (State)


condition : TransactionTriggerContext State -> Result String Bool
condition context =
    Ok True


action : TransactionTriggerContext State -> Result String ( Maybe State, Maybe Transaction )
action context =
    Ok ( Nothing, Nothing )
