module Main exposing (..)

import Debug exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


type alias Model =
    { query : String
    , results : List SearchResult
    }


type alias SearchResult =
    { id : Int
    , name : String
    , stars : Int
    }


type Msg
    = SetQuery String
    | DeleteById Int


initialModel : Model
initialModel =
    { query = "tutorial"
    , results =
        [ { id = 1
          , name = "TheSeamau5/elm-checkerboardgrid-tutorial"
          , stars = 66
          }
        , { id = 2
          , name = "grzegorzbalcerek/elm-by-example"
          , stars = 41
          }
        , { id = 3
          , name = "sporto/elm-tutorial-app"
          , stars = 35
          }
        , { id = 4
          , name = "jvoigtlaender/Elm-Tutorium"
          , stars = 10
          }
        , { id = 5
          , name = "sporto/elm-tutorial-assets"
          , stars = 7
          }
        ]
    }


elmHubHeader : Html Msg
elmHubHeader =
    header []
        [ h1 [] [ text "ElmHub" ]
        , span [ class "tagline" ] [ text "Like GitHub, but for Elm things." ]
        ]



-- (Debug.log "current model is" model)


view : Model -> Html Msg
view model =
    let
        filterResults list =
            List.filter (\item -> String.contains model.query item.name) model.results
    in
    div [ class "content" ]
        [ header []
            [ h1 [] [ text ("ElmHub - Search: " ++ model.query) ]
            , span [ class "tagline" ] [ text "Like GitHub, but for Elm things." ]
            ]
        , input
            [ class "search-query"

            -- , onInput (\text -> SetQuery text)
            , onInput SetQuery

            -- DONE onInput, set the query in the model
            , defaultValue model.query
            ]
            []
        , ul [ class "results" ]
            (List.map viewSearchResult (filterResults model.results))
        ]


viewSearchResult : SearchResult -> Html Msg
viewSearchResult result =
    li []
        [ span [ class "star-count" ] [ text (toString result.stars) ]
        , a [ href ("https://github.com/" ++ result.name), target "_blank" ]
            [ text result.name ]
        , button
            -- DONE add an onClick handler that sends a DeleteById msg
            [ class "hide-result", onClick (DeleteById result.id) ]
            [ text "X" ]
        ]


update : Msg -> Model -> Model
update msg model =
    -- DONE if we get a SetQuery msg, use it to set the model's query field,
    -- and if we get a DeleteById msg, delete the appropriate result
    let
        throwaway =
            Debug.log "current model is" model
    in
    case msg of
        DeleteById id ->
            { model | results = List.filter (\item -> not (item.id == id)) model.results }

        SetQuery query ->
            { model | query = query }


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { view = view
        , update = update
        , model = initialModel
        }
