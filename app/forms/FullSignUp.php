<?php
namespace app\forms;

require("../vendor/autoload.php");

use app\classes\Address;
use app\classes\User;
use app\exceptions\AddressException;
use app\exceptions\SignException;
use app\exceptions\UserException;
use app\models\SignManager;
use Nette\Forms\Form;

/**
 * Class FullSignUp
 * @package app\forms
 */
final class  FullSignUp{

    /**
     * @var Form $form
     */
    private Form $form;

    /**
     * @var User $user
     */
    private User $user;

    /**
     * @var Address $address
     */
    private Address $address;

    /**
     * @var SignManager $manager
     */
    private SignManager $manager;

    /**
     * FullSignUp constructor.
     */
    public function __construct()
    {
        $this->form = new Form;
    }

    /**
     * @return Form
     */
    public function create(callable $onSuccess): Form
    {
        $this->form->addEmail('email', 'E-mail:')
            ->setHtmlAttribute('placeholder', 'E-mail *')
            ->addRule($this->form::PATTERN,"Zadejte platný email", "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
            ->setRequired(true);
        $this->form->addSelect("areaCode", "Předvolba: ", ["+420"=>"+420", "+421"=>"+421", "+48"=>"+48"])
            ->setRequired();
        $this->form->addText('phone', 'Telefon:')
            ->setHtmlAttribute('placeholder', 'Telefon *')
            ->addRule($this->form::PATTERN, " Zadejte platné telefonní číslo",'^\d{3,3}(\ )?\d{3,3}(\ )?\d{3,3}$')
            ->setRequired(true);
        $this->form->addText('firstName', 'Jméno:')
            ->setHtmlAttribute("placeholder", "Jméno *")
            ->addRule($this->form::PATTERN, "Zadejte platné jméno",'^[A-ž-]{3,}$')
            ->setRequired(true);
        $this->form->addText('lastName', 'Příjmení:')
            ->setHtmlAttribute("placeholder", "Příjmení *")
            ->addRule($this->form::PATTERN, "Zadejte platné příjmení",'^[A-ž-]{3,}$')
            ->setRequired(true);


        $this->form->addText('username', 'Uživatelské jméno:')
            ->setHtmlAttribute("placeholder", "Uživatelské jméno *")
            ->addRule($this->form::PATTERN, "Uživatelské jméno nesplňuje podmínky",'^([A-ž]+[\d\_\-\.]*){3,}$')
            ->setRequired(true);
        $this->form->addPassword('password', 'Heslo:')
            ->setHtmlAttribute("placeholder", "Heslo *")
            ->addRule($this->form::PATTERN, "Heslo je příliš slabé",'^(?=.*[0-9]+)(?=.*[A-ž]*[A-Z]+).{8,}$')
            ->setRequired(true);


        $this->form->addCheckbox("firmCheckbox", "Nakupuji na firmu");
        $this->form->addText('ic', 'IČ:')
            ->setHtmlAttribute('placeholder', 'IČ *')
            ->addRule($this->form::PATTERN, 'Neplatný formát IČ','^\d{8,8}$')
            ->setRequired(true);
        $this->form->addText('dic', 'DIČ:')
            ->setHtmlAttribute('placeholder', 'DIČ *')
            ->addRule($this->form::PATTERN, 'Neplatný formát DIČ','^(CZ\d{8,10})|(SK\d{10,10})$')
            ->setRequired(true);
        $this->form->addCheckbox("dphCheckbox", "Nakupuji na firmu");
        $this->form->addText('firmName', 'Obchodní jméno:')
            ->setHtmlAttribute("placeholder", "Obchodní jméno *")
            ->addRule($this->form::PATTERN, "Neplatné jméno firmy",'^(([A-ž]+)([\d\_\-\.\&]*)){3,}$');


        $this->form->addSelect("country", "Země: ", ['CZE'=>'Česká republika', 'SVK'=>'Slovensko','AUT'=>'Rakousko','POL'=>'Polsko', 'DEU'=>'Německo'])
            ->setRequired();
        $this->form->addText("address1", "Ulice a č. p.")
            ->setHtmlAttribute("placeholder", "Ulice a č. p. *")
            ->addRule($this->form::PATTERN, "Neplatný adresní řádek",'^[A-ž\ \,\.\-\/\d]{2,}$')
            ->setRequired(true);
        $this->form->addText("address2", "2. adresní řádek")
            ->setHtmlAttribute("placeholder", "2. adresní řádek")
            ->addRule($this->form::PATTERN, "Neplatný adresní řádek", '^[A-ž\ \,\.\-\/\d]{2,}$');
        $this->form->addText("city", "Obec:")
            ->setHtmlAttribute("placeholder", "Obec *")
            ->addRule($this->form::PATTERN, "Neplatný název města",'^([A-ž]+(\ )*){2,}$')
            ->setRequired(true);
        $this->form->addText("zipCode", "PSČ:")
            ->setHtmlAttribute("placeholder", "PSČ *")
            ->addRule($this->form::PATTERN, "Neplatné PSČ",'^\d{3,3}(\ )?\d{2,2}$')
            ->setRequired(true);

        $this->form->addSubmit("submit", "Registrovat");

        $this->form->onSuccess[] = function (Form $form, array $values) use ($onSuccess) : void
        {
            try{
                $this->address = new Address();
                $this->address->setValues(
                    $values["firstName"],
                    $values["lastName"],
                    $values["firmName"],
                    $values["phone"],
                    $values["areaCode"],
                    $values["address1"],
                    $values["address2"],
                    $values["city"],
                    $values["country"],
                    $values["zipCode"],
                    $values["dic"],
                    $values["ic"]
                );
            }catch (AddressException $exception){
                $this->form->addError($exception->getMessage());
                return;
            }

            try{
                $this->user = new User();
                $this->user->setValues(
                    $values["email"],
                    $values["username"],
                    $values["password"],
                    $values["phone"],
                    $values["areaCode"],
                    0,
                    "user",
                    6,
                    5,
                    $this->user->getRegistered_date(),
                    $values["firstName"],
                    $values["lastName"],
                    $this->address,
                    new Address()
                );
            }catch (UserException $exception){
                $this->form->addError($exception->getMessage());
                return;
            }

            try {
                $this->manager::SignUp($this->user);
            }catch (SignException $exception){
                $this->form->addError($exception->getMessage());
                return;
            }

            $onSuccess();
        };
        return $this->form;
    }
}
