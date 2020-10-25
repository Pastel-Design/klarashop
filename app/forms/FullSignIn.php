<?php

namespace app\forms;

require("../vendor/autoload.php");

use app\exceptions\SignException;
use app\models\SignManager;
use Nette\Forms\Form;

/**
 * Class FullSignUp
 * @package app\forms
 */
final class  FullSignIn
{

    /**
     * @var Form $form
     */
    private Form $form;

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
        $this->form->addText('login', 'Uživatelské jméno nebo email:')
            ->setHtmlAttribute("placeholder", "Uživatelské jméno nebo email *")
            ->setRequired(true);
        $this->form->addPassword('password', 'Heslo:')
            ->setHtmlAttribute("placeholder", "Heslo *")
            ->setRequired(true);

        $this->form->addSubmit("submit", "Přihlásit");

        if($this->form->isSuccess()){
            $values = $this->form->getValues("array");
            $_SESSION["karel"]="karel";
            try {
                SignManager::SignIn($values["login"],$values["password"]);
            } catch (SignException $exception) {
                $this->form->addError($exception->getMessage());
            }

            $onSuccess();
        }

        return $this->form;
    }
}