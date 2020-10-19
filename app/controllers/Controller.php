<?php


abstract class Controller
{
    /**Třída kontroleru má vlastnosti data, pohled který se má vypsat v defaultní šabloně a hlavičku kvůli SEO */
    protected $data = array();
    protected $view = "";
    protected $head = ['title' => '', 'keywords' => '', 'description' => '', 'css'=>'', 'js'=>''];

    /**
     * @var $latte
     * Proměnná pro objekt třídy Latte\Engine
     */
    protected $latte;


    /**
     * Controller constructor.
     */
    public function __construct()
    {
        $this->latte = new Latte\Engine();
       // $this->latte->setTempDirectory('/app/views');
    }

    /**Definice abstraktní třídy pro ostatní kontrolery které ji dědí */
    abstract function process($params);

    /** funkce pro výpis pohledu
     *  funkce extract položky v data zpřístupní jako klasické proměnné, to znamená že $pole["polozka"] je nyní přístupná jako $polozka
     *  díky tomu můžou kontrolery vkládat data do pole data a v pohledu k nim přistupujeme jako ke klasickým proměnným.
     *  Druhá funkce extract extractuje data bez ošetřující funkce, jsou odlišený od těch ošetřených 
     *  prefixem, který pokud není specifikováno, jakože dole není, je defaultně dolní podtržízko
     * 
     *  na konec se requieruje pohled ze složky views
     */
    public function writeView()
    {
        if ($this->view) {
            $this->view = __DIR__. "/../../app/views/" . $this->view . ".latte";
            $this->latte->render($this->view, ["head" => $this->head,"data"=> $this->data]);
        }
    }

    /**Funkce pro přesměrování z jakýhokoliv důvodu, nejčastěji použita pokud hledaná stránka není nalezena */
    public function reroute($url)
    {
        header("Location: /$url");
        header("Connection: close");
        exit;
    }
    /**
     *Sets value of $this->$view and sets css and js variables
     * @param String $view
     */
    public function setView($view)
    {
        $this->view = $view;
        $this->head['css'] = "styles/".$this->view . ".min.css";
        $this->head['js'] = "scripts/".$this->view . ".min.js";
    }
    public function getView()
    {
        return $this->view;
    }
    /**
     * Funkce pro převedení klasického formátu názvu do pomlčkového formátu
     * transliterator je PHP funkce pomocí který odstranuju velky/maly pismena a diakritiku
     * následuje regex kterej všechny znaky kromě čísel a znaků převede na pomlčky
     */
    public function basicToDash($argument){
        $transliterator = Transliterator::createFromRules(':: Any-Latin; :: Latin-ASCII; :: NFD; :: [:Nonspacing Mark:] Remove; :: Lower(); :: NFC;', Transliterator::FORWARD);
        return preg_replace("[\W+]","-",$transliterator->transliterate($argument));
    }
}