module Media.Messages exposing (Msg(..))

import Media.Model exposing (Position, MediaState, Error)


type Msg
    = Play
    | Pause
    | Seek Position
    | StateChanged MediaState
    | DurationChanged Float
    | PlaybackPositionChanged Position
    | ErrorHappened Error
