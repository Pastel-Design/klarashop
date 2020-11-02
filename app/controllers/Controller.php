<?php

namespace app\controllers;

use app\models\CategoryManager;
use Latte\Engine;
use Transliterator;


/**
 * Class Controller
 * @package app\controllers
 */

abstract class Controller
{
    /**
     * @var array $data
     */
    protected array $data = [];

    /**
     * @var string $view
     */
    protected string $view = "";

    /**
     * @var array $head
     */
    protected array $head = ['page_title' => '', 'page_keywords' => '', 'page_description' => '', 'css' => '', 'js' => '','flashes'=>[]];

    /**
     * @var string $controllerName
     */
    public string $controllerName;

    /**
     * @var Engine $latte
     * Proměnná pro objekt třídy Latte\Engine
     */
    private Engine $latte;

    private CategoryManager $categoryManagerNav;

    public function __construct()
    {
        $this->latte = new Engine();
        $this->latte->addFilter("convertCountry",function ($countryCode){
            switch ($countryCode){
                case "CZE":
                    return "Česká republika";
                case "SVK":
                    return "Slovensko";
                case "AUT":
                    return "Rakousko";
                case "DEU":
                    return "Německo";
                case "POL":
                    return "Polsko";
                default:
                    return $countryCode;
            }
        });
        $this->categoryManagerNav = new CategoryManager();
    }

    /**
     * Definice abstraktní třídy pro ostatní kontrolery které ji dědí
     * @param array $params
     * Main url parameters
     * @param array|null $gets
     * Get parameters from url
     */
    abstract function process(array $params,array $gets=null);

    /**
     * Renders selected view
     * @return void
     */
    public function writeView(): void
    {
        if ($this->view) {
            $this->view = __DIR__ . "/../../app/views/" . $this->controllerName . "/" . $this->view . ".latte";
            $params = array_merge($this->head,$this->data);
            $params["categories"] = $this->categoryManagerNav->selectCategories();
            $this->latte->render($this->view, $params);
        }
    }


    /**
     * Sets value of $this->$view and sets css and js variables
     * @param string $view
     * View name
     * @return void
     */
    public function setView(string $view): void
    {
        $this->view = $view;
        $this->head['css'] = $this->view . ".css";
        $this->head['js'] = $this->view . ".js";
    }

    /**
     * View getter
     * @return string|null
     */
    public function getView(): ?string
    {
        return $this->view;
    }
    /**
     * Convert standard names to dash-based style
     * @param string $argument
     * @return string
     */
    public function basicToDash(string $argument): string
    {
        $transliterator = Transliterator::createFromRules(':: Any-Latin; :: Latin-ASCII; :: NFD; :: [:Nonspacing Mark:] Remove; :: Lower(); :: NFC;', Transliterator::FORWARD);
        return preg_replace("[\W+]", "-", $transliterator->transliterate($argument));
    }

    /**
     * Adds flash message to view trough head
     * @param string $message
     * Message to render
     * @param string $type default = "info"
     * Message type to differentiate in css
     */
    protected function addFlashMessage(string $message, string $type = "info") : void
    {
        $this->head["flashes"][] = ["message"=>$message, "type"=>$type];
    }
}
