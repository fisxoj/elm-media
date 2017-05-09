module Media
    exposing
        ( --  -- tags
          --   audio
          -- , video
          --   -- events
          -- , onPlaybackPositionChanged
          -- , onDurationChanged
          -- tasks
          play
        , pause
        , seek
          -- error
        )

{-| Ye Grand Ole Media Module

# Commands
@docs play, pause, seek
-}

import Native.Media
import Media.View exposing (audio)
import Media.Events exposing (onPlaybackPositionChanged, onDurationChanged)
import Media.Model exposing (Position, Id, Position, Error, MediaState)
import Platform exposing (Task)


{-| play
-}
play : Id -> Task Error MediaState
play id =
    Native.Media.play id


{-| pause
-}
pause : Id -> Task Error MediaState
pause id =
    Native.Media.pause id


{-| seek
-}
seek : Id -> Position -> Task Error MediaState
seek id time =
    Native.Media.seek id time
