module Media.State exposing (MediaState(..))


type MediaState
    = Preroll
    | Loaded
    | Playing
    | Paused
