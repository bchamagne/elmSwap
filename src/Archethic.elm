module Archethic exposing (..)


type TransactionType
    = Transfer
    | Data
    | Contract
    | Token


type alias TransactionAddress =
    String


type alias Amount =
    Float


type alias TokenRef =
    { address : TransactionAddress
    , id : Int
    }


type alias UcoTransfer =
    { from : TransactionAddress
    , to : TransactionAddress
    , amount : Amount
    }


type alias TokenTransfer =
    { from : TransactionAddress
    , to : TransactionAddress
    , amount : Amount
    , token : TokenRef
    }


type alias TransactionData =
    { transfers : ( List UcoTransfer, List TokenTransfer ) }


type alias Transaction =
    { address : TransactionAddress
    , type_ : TransactionType
    , data : TransactionData
    }
