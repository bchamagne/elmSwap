module Dex.Action.AddLiquidity exposing (action, condition, decoder)

import Archethic exposing (..)
import Archethic.Contract exposing (..)
import Dex.Helpers exposing (getFinalAmounts, getLPTokenToMint, getPoolBalances, getUserTransfersAmount)
import Dex.State exposing (State)
import Json.Decode as D exposing (Decoder)


type alias Request =
    { token1MinAmount : Amount
    , token2MinAmount : Amount
    }


decoder : Decoder Request
decoder =
    D.map2 Request
        (D.field "token1_min_amount" D.float)
        (D.field "token2_min_amount" D.float)


condition : Request -> TransactionTriggerContext State -> Result String Bool
condition req ctx =
    case getUserTransfersAmount ctx.triggerTx of
        ( 0, _ ) ->
            Ok False

        ( _, 0 ) ->
            Ok False

        transferedAmounts ->
            let
                ( token1FinalAmount, token2FinalAmount ) =
                    if ctx.state.lpTokenSupply /= 0 then
                        getFinalAmounts
                            transferedAmounts
                            ctx.state.reserves
                            ( req.token1MinAmount, req.token2MinAmount )

                    else
                        transferedAmounts
            in
            if token1FinalAmount /= 0 then
                let
                    ( token1Balance, token2Balance ) =
                        getPoolBalances

                    token1Amount =
                        token1FinalAmount + token1Balance - Tuple.first ctx.state.reserves

                    token2Amount =
                        token2FinalAmount + token2Balance - Tuple.second ctx.state.reserves

                    lpTokenToMint =
                        getLPTokenToMint ( token1Amount, token2Amount ) ctx.state
                in
                Ok (lpTokenToMint > 0)

            else
                Ok False


action : Request -> TransactionTriggerContext State -> Result String ( Maybe State, Maybe Transaction )
action req ctx =
    Err "todo"
