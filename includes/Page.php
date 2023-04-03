<?php

class Page
{
    private $header;
    private $body;
    private $footer;


    function __construct()
    {
       $this->setHeader();
       $this->setFooter();
    }


    private function setHeader()
    {
        $this->header='
        <!DOCTYPE html>
            <html lang="es">
            <head>
            <meta charset="UTF-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Pibvbo</title>
            <link rel="icon" type="image/x-icon" href="imgs/favicon.ico">
            <link href="styles/pib-style.css" rel="stylesheet" type="text/css">
            </head>
            <header>
                <img class="logo" src="imgs/Pib.png" alt="Pibvbo">
            </header>
                    <body class="bg-light">';
    }





    public function setBody($body)
    {
        $this->body=$body;
    }


    private function setFooter()
    {
        $this->footer='</body>
        </html>';
    }


    public function getHtml()
    {
        $Pagina=$this->header;
        $Pagina.=$this->body;
        $Pagina.=$this->footer;
        return $Pagina;
    }


}