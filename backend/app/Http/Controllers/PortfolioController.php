<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class PortfolioController extends Controller
{
    public function getPortfolioData()
    {
        $titles = [
            "description" => "Projet d'étude portant sur l'optimisation d'un site web. Retrait de jQuery et réécriture des éléments en JavaScript vanilla. Purge des elements inutiles de bootstrap. La difficulté était de trouver l'équilibre entre le temps de travail et le gain de performance.",
            "title" => "Nina Carducci\u{202F}:",
            "url" => "../../assets/images/portfolio/portfolio1.webp",
            "link" => "https://github.com/pierisRassat/oc-projet5"
        ];

        return response()->json($titles);
    }
}

