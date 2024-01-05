module Archethic.Contract exposing (..)

import Archethic exposing (..)
import Time


type alias ActionName =
    String


type alias FunctionName =
    String


type alias ArgsJson =
    String


type alias CronInterval =
    String


type alias FunctionContext state =
    { contractTx : Transaction
    , datetime : Time.Posix
    , state : state
    }


type alias TransactionTriggerContext state =
    { contractTx : Transaction
    , triggerTx : Transaction
    , datetime : Time.Posix
    , state : state
    }


type alias DateTimeTriggerContext state =
    { contractTx : Transaction
    , datetime : Time.Posix
    , state : state
    }
