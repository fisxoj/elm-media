module Media.Model exposing (Model, Id, Position, Error, MediaState(..), media)


type alias Position =
    Float


type alias Id =
    String


type Error
    = NotFound Id
    | InvalidPosition Id Position


type MediaState
    = Preroll
    | Loaded
    | Playing
    | Paused


type alias Model =
    { id : Id
    , src : Maybe String
    , state : MediaState
    , position : Position
    , duration : Float
    }


media : Model
media =
    { id = ""
    , src = Nothing
    , state = Preroll
    , position = 0.0
    , duration = 0
    }
