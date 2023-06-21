module Page.Portfolio exposing (Model, Msg(..), init, update, view)

import Basics exposing (modBy)
import Html exposing (Html, a, button, div, img, output, text)
import Html.Attributes exposing (alt, class, href, src, target)
import Html.Events exposing (onClick)
import List exposing (filter, indexedMap)



-- MODEL


type alias Model =
    { images : List ImageData
    , technologies : List (List String)
    , currentIndex : Int
    , totalIndex : Int
    }


type alias ImageData =
    { title : String
    , description : String
    , url : String
    , isActive : Bool
    , link : String
    }


init : Model
init =
    let
        images =
            [ { description = "Projet d'étude portant sur l'optimisation d'un site web. Retrait de jQuery et réécriture des éléments en JavaScript vanilla. Purge des elements inutiles de bootstrap."
              , url = "../../assets/images/portfolio/portfolio1.webp"
              , isActive = False
              , title = "Nina Carducci\u{202F}: "
              , link = "https://github.com/pierisRassat/oc-projet5"
              }
            , { description = "Projet d'étude portant sur la création d'un frontend en React.js, les composants, les props, les états de l'application, la gestion des effets de bord."
              , url = "../../assets/images/portfolio/portfolio2.webp"
              , isActive = False
              , title = "Kasa\u{202F}: "
              , link = "https://github.com/pierisRassat/oc-projet6"
              }
            , { description = "Projet d'étude portant sur la création d'une API en Express.js, l'authentification et les différents endpoints."
              , url = "../../assets/images/portfolio/portfolio3.webp"
              , isActive = False
              , title = "Mon vieux grimoire\u{202F}: "
              , link = "https://github.com/pierisRassat/oc-projet7"
              }
            , { description = "Projet d'étude portant sur la création d'un frontend en elm, programmation fonctionnelle, gestion des états de l'application. Vous êtes présentement en train de l'utiliser."
              , url = "../../assets/images/portfolio/portfolio4.webp"
              , isActive = False
              , title = "Portfolio\u{202F}: "
              , link = "https://github.com/pierisRassat/oc-projet8"
              }
            ]

        technologies =
            [ [ "HTML", "CSS", "JavaScript" ]
            , [ "React", "CSS" ]
            , [ "Express", "MongoDB" ]
            , [ "Elm", "CSS" ]
            ]

        totalIndex =
            calculateTotalIndex images
    in
    { images = images
    , technologies = technologies
    , currentIndex = 0
    , totalIndex = totalIndex
    }


calculateTotalIndex : List a -> Int
calculateTotalIndex list =
    List.length list


type Msg
    = NextImage
    | PrevImage
    | ToggleImageActive Int



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        NextImage ->
            { model | currentIndex = getNextIndex model.currentIndex model.images }

        PrevImage ->
            { model | currentIndex = getPrevIndex model.currentIndex model.images }

        ToggleImageActive index ->
            let
                updatedImages =
                    List.indexedMap
                        (\i image ->
                            if i == index then
                                { image | isActive = not image.isActive }

                            else
                                image
                        )
                        model.images
            in
            { model | images = updatedImages }


getNextIndex : Int -> List a -> Int
getNextIndex currentIndex list =
    (currentIndex + 1) |> modBy (List.length list)


getPrevIndex : Int -> List a -> Int
getPrevIndex currentIndex list =
    (currentIndex - 1 + List.length list) |> modBy (List.length list)


outputIndic : String -> Html msg
outputIndic indic =
    output [ class "carousel-indicator" ] [ text indic ]


renderTechnologies : List String -> List (Html msg)
renderTechnologies technologies =
    List.map (\technology -> div [] [ text technology ]) technologies



-- VIEW


view : Model -> Html Msg
view model =
    let
        currentImage =
            indexedMap (\index image -> ( index, image )) model.images
                |> filter (\( index, _ ) -> index == model.currentIndex)
                |> List.head
                |> Maybe.withDefault ( 0, { title = "", description = "", url = "", isActive = False, link = "" } )
                |> Tuple.second

        imageElement =
            img
                [ src currentImage.url
                , class
                    ("carousel-img"
                        ++ (if currentImage.isActive then
                                " active"

                            else
                                ""
                           )
                    )
                , onClick (ToggleImageActive model.currentIndex)
                ]
                []

        modaleElement =
            div
                [ class
                    ("carousel-modale"
                        ++ (if currentImage.isActive then
                                " active"

                            else
                                ""
                           )
                    )
                , onClick (ToggleImageActive model.currentIndex)
                ]
                [ div [ class "modale-title" ] [ text currentImage.title ]
                , div [ class "modale-description" ] [ text currentImage.description ]
                , div [ class "modale-link" ] [ a [ href currentImage.link, target "_blank" ] [ text "Le code sur github \u{EB00}" ] ]
                ]

        navigation =
            div [ class "carousel" ]
                [ button [ onClick PrevImage ]
                    [ img [ src "../../assets/images/icons/carousel-prev.svg", alt "précédent" ] [] ]
                , imageElement
                , modaleElement
                , button [ onClick NextImage ]
                    [ img [ src "../../assets/images/icons/carousel-next.svg", alt "suivant" ] [] ]
                , outputIndic (String.fromInt (model.currentIndex + 1) ++ "/" ++ String.fromInt model.totalIndex)
                , technologiesElement
                ]

        technologiesElement =
            case
                indexedMap (\index techs -> ( index, techs )) model.technologies
                    |> List.filter (\( index, _ ) -> index == model.currentIndex)
                    |> List.head
            of
                Just ( _, technologies ) ->
                    div [ class "carousel-technologies" ] (renderTechnologies technologies)

                Nothing ->
                    div [] []
    in
    div [ class "portfolio-wrapper" ]
        [ navigation ]
