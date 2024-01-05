module Dex exposing (triggerFunction, triggerTransaction)

import Archethic exposing (..)
import Archethic.Contract exposing (..)
import Dex.Action.AddLiquidity as AddLiquidity
import Dex.Action.RemoveLiquidity as RemoveLiquidity
import Dex.Action.Swap as Swap
import Dex.Function.GetEquivalentAmount as GetEquivalentAmount
import Dex.Function.GetLPTokenToMint as GetLPTokenToMint
import Dex.Function.GetPoolInfos as GetPoolInfos
import Dex.Function.GetRatio as GetRatio
import Dex.Function.GetRemoveAmounts as GetRemoveAmounts
import Dex.Function.GetSwapInfos as GetSwapInfos
import Dex.State exposing (State)
import Json.Decode exposing (decodeString)


type Action
    = AddLiquidity AddLiquidity.Request
    | Swap Swap.Request
    | RemoveLiquidity


type Function
    = GetRatio GetRatio.Request
    | GetEquivalentAmount GetEquivalentAmount.Request
    | GetRemoveAmounts GetRemoveAmounts.Request
    | GetLPTokenToMint GetLPTokenToMint.Request
    | GetSwapInfos GetSwapInfos.Request
    | GetPoolInfos



---------------
-- INTERNAL (we can find a way to automatically do this)
---------------


triggerTransaction : ActionName -> ArgsJson -> TransactionTriggerContext State -> Result String ( Maybe State, Maybe Transaction )
triggerTransaction actionName argsJson context =
    case parseTriggerTransaction actionName argsJson of
        Ok (AddLiquidity req) ->
            AddLiquidity.condition req context
                |> Result.andThen
                    (\accepted ->
                        if accepted then
                            AddLiquidity.action req context

                        else
                            Err "Condition rejected"
                    )

        Ok RemoveLiquidity ->
            RemoveLiquidity.condition context
                |> Result.andThen
                    (\accepted ->
                        if accepted then
                            RemoveLiquidity.action context

                        else
                            Err "Condition rejected"
                    )

        Ok (Swap req) ->
            Swap.condition req context
                |> Result.andThen
                    (\accepted ->
                        if accepted then
                            Swap.action req context

                        else
                            Err "Condition rejected"
                    )

        Err reason ->
            Err reason


triggerFunction : FunctionName -> ArgsJson -> FunctionContext State -> Result String String
triggerFunction functionName argsJson context =
    case parseFunction functionName argsJson of
        Ok (GetRatio args) ->
            GetRatio.run args
                |> Result.map GetRatio.encoder

        Ok (GetEquivalentAmount args) ->
            GetEquivalentAmount.run args context
                |> Result.map GetEquivalentAmount.encoder

        Ok (GetLPTokenToMint args) ->
            GetLPTokenToMint.run args context
                |> Result.map GetLPTokenToMint.encoder

        Ok (GetSwapInfos args) ->
            GetSwapInfos.run args context
                |> Result.map GetSwapInfos.encoder

        Ok GetPoolInfos ->
            GetPoolInfos.run context
                |> Result.map GetPoolInfos.encoder

        Ok (GetRemoveAmounts args) ->
            GetRemoveAmounts.run args context
                |> Result.map GetRemoveAmounts.encoder

        Err reason ->
            Err reason


parseFunction : String -> String -> Result String Function
parseFunction functionName argsJson =
    case functionName of
        "get_ratio" ->
            case decodeString GetRatio.decoder argsJson of
                Ok args ->
                    Ok <| GetRatio args

                Err _ ->
                    Err "invalid function arguments"

        "get_equivalent_amount" ->
            case decodeString GetEquivalentAmount.decoder argsJson of
                Ok args ->
                    Ok <| GetEquivalentAmount args

                Err _ ->
                    Err "invalid function arguments"

        "get_remove_amounts" ->
            case decodeString GetRemoveAmounts.decoder argsJson of
                Ok args ->
                    Ok <| GetRemoveAmounts args

                Err _ ->
                    Err "invalid function arguments"

        "get_pool_infos" ->
            Ok GetPoolInfos

        "get_swap_infos" ->
            case decodeString GetSwapInfos.decoder argsJson of
                Ok args ->
                    Ok <| GetSwapInfos args

                Err _ ->
                    Err "invalid function arguments"

        "get_lp_token_to_mint" ->
            case decodeString GetLPTokenToMint.decoder argsJson of
                Ok args ->
                    Ok <| GetLPTokenToMint args

                Err _ ->
                    Err "invalid function arguments"

        _ ->
            Err "invalid function name"


parseTriggerTransaction : ActionName -> ArgsJson -> Result String Action
parseTriggerTransaction actionName argsJson =
    case actionName of
        "add_liquidity" ->
            case decodeString AddLiquidity.decoder argsJson of
                Ok args ->
                    Ok <| AddLiquidity args

                Err _ ->
                    Err "invalid trigger arguments"

        "remove_liquidity" ->
            Ok RemoveLiquidity

        "swap" ->
            case decodeString Swap.decoder argsJson of
                Ok args ->
                    Ok <| Swap args

                Err _ ->
                    Err "invalid trigger arguments"

        _ ->
            Err "invalid trigger"
