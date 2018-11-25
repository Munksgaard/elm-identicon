module Main exposing (..)

import Browser
import Html exposing (Html, Attribute)
import Html.Attributes exposing (style, placeholder)
import Html.Events exposing (onInput)
import Identicon
import Color

main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    String


init : Model
init =
    "Hello!"


type Msg =
    Input String


update : Msg -> Model -> Model
update (Input s) model =
    s


view : Model -> Html Msg
view model =
    let
        field = inputField []
        icon =
            Html.div iconStyle [ Identicon.identicon "200px" model ]
    in
        Html.div [] [
            field,
            icon,
            Html.text "Color: ",
            Identicon.defaultColor model |> Color.toCssString |> Html.text,
            Html.br [] [],
            Html.text "Hash: ",
            Identicon.defaultHash model |> String.fromInt |> Html.text
        ]


inputField : List (Html Msg) -> Html Msg
inputField =
    Html.input
    [
        placeholder "Enter a string...",
        onInput Input,
        style "width" "100%",
        style "height" "40px",
        style "padding" "10px 0",
        style "font-size" "2em",
        style "text-align" "center"
    ]


iconStyle : List (Attribute msg)
iconStyle =
    [
        style "width" "200px",
        style "height" "200px",
        style "padding" "50px 0",
        style "margin" "auto",
        style "font-size" "2em",
        style "text-align" "center"
    ]
