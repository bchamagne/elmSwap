module Dex.Helpers exposing (..)

import Archethic exposing (..)
import Archethic.Contract exposing (..)
import Dex.Constants exposing (contractAddress, token1Address, token2Address)
import Dex.State exposing (State)


getUserTransfersAmount : Transaction -> ( Amount, Amount )
getUserTransfersAmount transaction =
    let
        ( ucoTransfersToContract, tokenTransfersToContract ) =
            Tuple.mapBoth
                (List.filter (\t -> t.to == contractAddress))
                (List.filter (\t -> t.to == contractAddress))
                transaction.data.transfers

        extractTokenAmount : TransactionAddress -> List UcoTransfer -> List TokenTransfer -> Amount
        extractTokenAmount tokenAddr ucoTransfers tokenTransfers =
            if tokenAddr == "UCO" then
                ucoTransfers
                    |> List.map .amount
                    |> List.foldl (+) 0.0

            else
                tokenTransfers
                    |> List.filter (\t -> t.token.address == tokenAddr)
                    |> List.map .amount
                    |> List.foldl (+) 0.0
    in
    ( extractTokenAmount token1Address ucoTransfersToContract tokenTransfersToContract
    , extractTokenAmount token2Address ucoTransfersToContract tokenTransfersToContract
    )


getPoolBalances : ( Amount, Amount )
getPoolBalances =
    ( 42.0123, 23.58 )


getFinalAmounts : ( Amount, Amount ) -> ( Amount, Amount ) -> ( Amount, Amount ) -> ( Amount, Amount )
getFinalAmounts ( token1Transfered, token2Transfered ) ( token1Reserve, token2Reserve ) ( token1Min, token2Min ) =
    case ( token1Reserve, token2Reserve ) of
        ( 0, _ ) ->
            ( token1Transfered, token2Transfered )

        ( _, 0 ) ->
            ( token1Transfered, token2Transfered )

        _ ->
            let
                token1Equivalent =
                    token2Transfered * (token1Reserve / token2Reserve)

                token2Equivalent =
                    token1Transfered * (token2Reserve / token1Reserve)
            in
            if token2Equivalent <= token2Transfered && token2Equivalent >= token2Min then
                ( token1Transfered, token2Equivalent )

            else if token1Equivalent <= token1Transfered && token1Equivalent >= token1Min then
                ( token1Equivalent, token2Transfered )

            else
                ( 0.0, 0.0 )


getLPTokenToMint : ( Amount, Amount ) -> State -> Amount
getLPTokenToMint ( token1, token2 ) state =
    case ( state.lpTokenSupply, state.reserves ) of
        ( 0, _ ) ->
            sqrt (token1 * token2)

        ( _, ( 0, _ ) ) ->
            sqrt (token1 * token2)

        ( _, ( _, 0 ) ) ->
            sqrt (token1 * token2)

        ( lpTokenSupply, ( token1Reserve, token2Reserve ) ) ->
            let
                mintAmount1 =
                    (token1 * lpTokenSupply) / token1Reserve

                mintAmount2 =
                    (token2 * lpTokenSupply) / token2Reserve

                lpTokenToMint =
                    if mintAmount1 < mintAmount2 then
                        mintAmount1

                    else
                        mintAmount2
            in
            lpTokenToMint
