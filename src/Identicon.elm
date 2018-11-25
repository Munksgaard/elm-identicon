module Identicon exposing (custom, defaultColor, defaultHash, identicon)

{-| Generate an identicon from a string.

# Creating
@docs identicon, custom

# Defaults
@docs defaultHash, defaultColor

-}

import Char
import Color exposing (Color)
import Bitwise
import Html exposing (Html)
import Svg exposing (Svg)
import Svg.Attributes as Attr
import String
import Tuple


{-| Generate a identicon from a string

    main =
      identicon "200px" "Hello identicon!"
-}
identicon : String -> String -> Html msg
identicon =
    custom defaultHash defaultColor


{-| Creates an identicon with your own hasher/colorer where the string is
passed into both the hasher and colorer.  Here's how to create an identicon
that's always the color red:

    import Color exposing (rgb255)

    main =
        custom defaultHash (always <| rgb255 255 0 0) "200px" "Hello Identicon!"
-}
custom : (String -> Int) -> (String -> Color) -> String -> String -> Html msg
custom hasher colorer size string =
    let
        hash : Int
        hash =
            hasher string

        pixels : List (Svg msg)
        pixels =
            List.range 0 14
                |> List.filter (\i -> hash |> Bitwise.shiftRightBy i |> modBy 2 |> (==) 0)
                |> List.map toCoordinates
                |> (\l -> List.append l <| List.map mirror l)
                |> List.map pixel
    in
        Svg.svg
            [ Attr.viewBox "0 0 5 5"
            , Attr.fill (colorer string |> Color.toCssString)
            , Attr.height size
            , Attr.width size
            , Attr.shapeRendering "crispEdges"
            ]
            pixels


{-| Generate a color from a string

This generates the same color that would be used in the identicon.

-}
defaultColor : String -> Color
defaultColor =
    color << defaultHash


{-| One-at-a-Time Hash

  Taken from http://www.burtleburtle.net/bob/hash/doobs.html.

-}
defaultHash : String -> Int
defaultHash =
    let
        step : Int -> Int -> Int
        step b =
            (+) b
                >> (\x -> x + Bitwise.shiftLeftBy x 10)
                >> (\x -> Bitwise.xor x (Bitwise.shiftRightBy x 6))
    in
        String.toList
            >> List.foldr (Char.toCode >> step) 0
            >> (\x -> x + Bitwise.shiftLeftBy x 3)
            >> (\x -> Bitwise.xor x (Bitwise.shiftRightBy x 11))
            >> (\x -> x + Bitwise.shiftLeftBy x 15)


toCoordinates : Int -> ( Int, Int )
toCoordinates i =
    let
        x : Int
        x =
            floor (toFloat i / 5)

        y : Int
        y =
            modBy 5 i
    in
        ( x, y )


mirror : ( number, a ) -> ( number, a )
mirror =
    Tuple.mapFirst ((-) 4)


color : Int -> Color
color hash =
    let
        hue = toFloat (modBy 100 hash) / 100
    in
        Color.hsl hue 0.5 0.7


pixel : ( Int, Int ) -> Svg msg
pixel ( x, y ) =
    Svg.rect
        [ Attr.y <| String.fromInt y
        , Attr.x <| String.fromInt x
        , Attr.width "1"
        , Attr.height "1"
        ]
        []
