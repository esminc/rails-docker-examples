module Main exposing (..)

import Browser
import Html exposing (Html, h1, ul, li, div, span, text)
import Html.Attributes exposing (style)
import Http
import Json.Decode exposing (Decoder, field, int, string)
import String

-- MODEL

type Model
  = Failure
  | Loading
  | Success (List Visit)

type alias Visit =
  { id : Int
  , visited_at : String
  , created_at : String
  , updated_at : String
  }

visitDecoder : Decoder Visit
visitDecoder =
  Json.Decode.map4 Visit
    (field "id" int)
    (field "visited_at" string)
    (field "created_at" string)
    (field "updated_at" string)

visitListDecoder : Decoder (List Visit)
visitListDecoder =
  Json.Decode.list visitDecoder

-- INIT

init : (Model, Cmd Message)
init =
  ( Loading
  , Http.get
    { url = "/visits"
    , expect = Http.expectJson GotText visitListDecoder
    }
  )

-- VIEW

view : Model -> Html Message
view model =
  case model of
    Failure ->
      text "A requests for the API failed"
    Loading ->
      text "Loading..."
    Success visitList ->
      div [] [
        h1 [] [text "Listing visits"],
        ul []
          (List.map (\l ->
            li [] [
              span [] [text (String.fromInt l.id)],
              span [] [text ": "],
              span [] [text l.visited_at]
              ]
          ) visitList)
      ]

-- MESSAGE

type Message
  = GotText (Result Http.Error (List Visit))

-- UPDATE

update : Message -> Model -> (Model, Cmd Message)
update message model =
  case message of
    GotText result ->
      case result of
        Ok visitList ->
          (Success visitList, Cmd.none)
        Err e ->
          (Failure, Cmd.none)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Message
subscriptions model =
  Sub.none

-- MAIN

main : Program (Maybe {}) Model Message
main =
  Browser.element
    {
      init = always init,
      view = view,
      update = update,
      subscriptions = subscriptions
    }
