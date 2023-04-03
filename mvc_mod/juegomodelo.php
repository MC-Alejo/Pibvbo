<?php
class Juego {
    private $ID;
    private $preguntas;

    private $mysqli;


    public function __construct()
    {
        $this->mysqli = new mysqli("localhost","root","","pibvbo");
    }

    public function SetId($ID)
    {
        if(is_int($ID))
        {
            $this->ID=$ID;
        }

    }

    public function cargarpreguntas()
    {
        if(!empty($this->ID) or ($this->ID !== 0))
        {
            $sql = "SELECT idpregunta FROM juego_contiene_preguntas where idjuego=".$this->ID." order by idpregunta";

            if($resultado=$this->mysqli->query($sql))
            {
                if($resultado->num_rows > 0)
                {
                    $this->preguntas= array();
                    require_once('mvc_mod/preguntasmodel.php');
                    while($pregunta = $resultado->fetch_assoc())
                    {
                        $pregDB = new Pregunta();
                        $pregDB->SetPregunta($pregunta["idpregunta"]);
                        $preg["pregunta"]=$pregDB->getPregunta();
                        $preg["r0"]=$pregDB->getRespCorr();
                        $preg["r1"]=$pregDB->getRespFalsa1();
                        $preg["r2"]=$pregDB->getRespFalsa2();
                        array_push($this->preguntas,$preg);
                    }
                    
                }
                $resultado->close();
            }
            else
            {
                return false;
            }
        }
        else
        {
            return false;
        }
    }



    public function extraerPregunta($posicion)
    {
        if(isset($this->preguntas))
        {
            if(($posicion>=0) and($posicion<15))
            {
            return $this->preguntas[$posicion]["pregunta"];
            }
        }
    }

    public function extraerRespuestaCorrecta($posicion){
        if(isset($this->preguntas))
        {
            if(($posicion>=0) and($posicion<15))
            {
            return $this->preguntas[$posicion]["r0"];
            }
        }

    }

    public function extraerRespuestaFalsa1($posicion){

        if(isset($this->preguntas))
        {
            if(($posicion>=0) and($posicion<15))
            {
            return $this->preguntas[$posicion]["r1"];
            }
        }

    }

    public function extraerRespuestaFalsa2($posicion){

        if(isset($this->preguntas))
        {
            if(($posicion>=0) and($posicion<15))
            {
            return $this->preguntas[$posicion]["r2"];
            }
        }
    }



    public function cerrarconexion()
    {
        $this->mysqli->close();
    }
}


?>