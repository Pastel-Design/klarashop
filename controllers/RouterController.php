<?php
require("vendor/autoload.php");
use MatthiasMullie\Minify;

class RouterController extends Controller
{
    /**
    !   Router kontroler funguje jako směrovač, při načtení serveru se přesměruje veškerá komunikace na index.php a v něm je vytvořena instance tohodle směrovače
    !   Ten svojí funkcí process zpracuje požadavky zadané uživatelem, tedy buďto hledanou URL, nebo konkrétní parametry třeba při výpisu článku nebo produktu
     */

    /**vytvoří se samostatná vlastnost jako kontroler, není to z důvodu dědění z hlavní třídy kontroleru
     * do téhle vlastnosti se ukládá právě používaný kontroler pro obsluhu požadované stránky
     */
    protected $controller;

    //Funkce process slouží pro zpracování argumentů v url a výběr příslušného kontroleru pro obsluhu stránky
    public function process($params)
    {
        //Pro parsování url na parametry zavoláme funkci parseURL() 
        $parsedURL = $this->parseURL($params[0]);

        //Pokud v URL nejsou žádné parametry přesměrujeme na domovskou stránku 
        if (empty($parsedURL[0]))
            $this->reroute('home');
        //Jako aktuálně obsluhovaný kontroler se nastaví první parametr z URL v Camel notaci aby seděl název s případným názvem souboru 
        $controllerClass =  $this->dashToCamel(array_shift($parsedURL)) . 'Controller';
        //Pokud soubor s názvem kontroleru existuje, nastaví se název třídy kontroleru jako obsluhovaný kontroler do vlastnosti objektu směrovače
        if (file_exists('controllers/' . $controllerClass . '.php'))
            $this->controller = new $controllerClass;
        //v opačném případě přesměrujeme na chybovou stránku s errorem 404
        else
            $this->reroute('error/404');

        //Vybraný kontroler si zpracuje parametry z URL
        $this->controller->process($parsedURL);
        $controllerName = $this->controller->view;
        //Knihovna Minify zminimalizuje css a js soubor pro daný pohled, pro více info https://packagist.org/packages/matthiasmullie/minify
        $minifier = new Minify\CSS;
        $minifier->add("styles/" . $controllerName . ".css", "styles/style.css");
        $minifier->minify("styles/minified/" . $controllerName . ".min.css");
        $minifier = new Minify\JS;
        $minifier->add("scripts/" . $controllerName . ".js", "scripts/script.js");
        $minifier->minify("scripts/minified/" . $controllerName . ".min.js");

        //do hlavičky se nastaví obsah hlavičky tak jak je vytvořil kontroler
        $this->data['css'] = $controllerName . ".min.css";
        $this->data['js'] = $controllerName . ".min.js";
        //nastavíme základní layout šablonu
        $this->controller->writeView();
    }
    private function parseURL($url)
    {
        $parsedURL = parse_url($url);
        $parsedURL["path"] = ltrim($parsedURL["path"], "/");
        $parsedURL["path"] = trim($parsedURL["path"]);
        $parsedURL = explode("/", $parsedURL["path"]);
        return $parsedURL;
    }
    private function dashToCamel($text)
    {
        return str_replace(' ', '', ucwords(str_replace('-', ' ', $text)));
    }
}