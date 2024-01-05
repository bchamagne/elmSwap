module Dex.State exposing (State, init)

import Archethic exposing (..)


type alias State =
    { lpTokenSupply : Amount
    , reserves : ( Amount, Amount )
    }


init : State
init =
    { lpTokenSupply = 0.0
    , reserves = ( 0.0, 0.0 )
    }
