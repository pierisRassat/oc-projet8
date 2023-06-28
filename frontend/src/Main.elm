module Main exposing (..)

import Browser
import Html exposing (Html, a, button, div, footer, h1, header, img, nav, p, section, text)
import Html.Attributes exposing (alt, class, href, src)
import Html.Events exposing (onClick)
import Page.Home as Home
import Page.Portfolio as Portfolio
import Page.Resume as Resume



-- MODEL


type alias Model =
    { currentPage : Page
    , portfolio : Portfolio.Model
    }


type Page
    = HomePage
    | PortfolioPage
    | ResumePage



-- UPDATE


type Msg
    = ChangePage Page
    | PortfolioMsg Portfolio.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangePage page ->
            { model | currentPage = page }

        PortfolioMsg portfolioMsg ->
            case model.currentPage of
                PortfolioPage ->
                    { model | currentPage = PortfolioPage }
                        |> (\updatedModel ->
                                { updatedModel | currentPage = PortfolioPage }
                           )
                        |> (\updatedModel ->
                                { updatedModel | portfolio = Portfolio.update portfolioMsg updatedModel.portfolio }
                           )

                HomePage ->
                    model

                ResumePage ->
                    model



-- VIEW


view : Model -> Html Msg
view model =
    let
        -- HEADER DEF
        logo =
            img [ class "logo", src "../assets/images/logo/logo.png", alt "logo" ] []

        headerTitle =
            h1 [] [ text "framend" ]

        navigation =
            nav []
                [ p [ class "linkedin" ] [ a [ href "https://www.linkedin.com/in/pieris-rassat-426751280/" ] [ text "\u{F0E1}" ] ]
                , p [ class "github" ] [ a [ href "https://github.com/pierisRassat" ] [ text "\u{EB00}" ] ]
                , p [ class "gitlab" ] [ a [ href "https://gitlab.com/web-apps3574524" ] [ text "\u{F0BA0}" ] ]
                , button [ onClick (ChangePage HomePage) ] [ text "Accueil" ]
                , button [ onClick (ChangePage PortfolioPage) ] [ text "Portfolio" ]
                , button [ onClick (ChangePage ResumePage) ] [ text "CV" ]
                ]

        -- CONTENT DEF
        content : Html Msg
        content =
            case model.currentPage of
                HomePage ->
                    Home.view

                PortfolioPage ->
                    Portfolio.view model.portfolio
                        |> Html.map PortfolioMsg

                ResumePage ->
                    Resume.view

        -- FOOTER DEF
        elmVersion : String
        elmVersion =
            "0.19.1"

        scrollToTopLink : Html msg
        scrollToTopLink =
            a [ class "scroll-to-top-link", href "#top" ]
                [ img [ src "./assets/images/icons/drop-down-open.svg", alt "Vers tête de page" ] []
                ]

        footerSection =
            footer []
                [ scrollToTopLink
                , div [ class "footer-nav" ] [ navigation ]
                , div [ class "footer-signature" ] [ text ("Made with ❤ and with Elm lang v" ++ elmVersion) ]
                ]
    in
    div [ class "app" ]
        [ header [ class "header" ]
            [ div [ class "logo-wrapper" ]
                [ logo
                , headerTitle
                ]
            , navigation
            ]
        , section [ class "content" ] [ content ]
        , footerSection
        ]



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }



-- INIT


init : Model
init =
    { currentPage = HomePage
    , portfolio = Portfolio.init
    }
