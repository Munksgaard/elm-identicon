import Color
import Identicon

main =
    Identicon.custom Identicon.defaultHash (always <| Color.rgb255 255 0 0) "200px" "Hello Identicon!"
