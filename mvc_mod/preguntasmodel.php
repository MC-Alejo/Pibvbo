<?php
    class Pregunta{
    private $ID;

    private $pregunta;
    private $respuestaCorrecta;
    private $respuestaFalsa1;
    private $respuestaFalsa2;

    private $mysqli;


    public function __construct()
    {
        $this->mysqli = new mysqli("localhost","root","","pibvbo");
    }


    public function SetPregunta($ID)
    {
        if(ctype_alnum($ID) == true)
        {
            $sql = "SELECT preg, correcta, falsa1, falsa2 FROM pregunta where ID='".$ID."'";

            if ( $resultado = $this->mysqli->query($sql) )
		    {
			    if ( $resultado->num_rows > 0 )
 			    {
                 $objeto = $resultado->fetch_assoc();
                 $this->ID=$ID;
                 $this->pregunta=$objeto["preg"];
                 $this->respuestaCorrecta=$objeto["correcta"];
                 $this->respuestaFalsa1=$objeto["falsa1"];
                 $this->respuestaFalsa2=$objeto["falsa2"];
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
        else
        {
            return false;
        }

    }

    public function getPregunta()
    {
        return $this->pregunta;
    }

    
    public function getRespCorr()
    {
        return $this->respuestaCorrecta;
    }
    
    public function getRespFalsa1()
    {
        return $this->respuestaFalsa1;
    }

    public function getRespFalsa2()
    {
        return $this->respuestaFalsa2;
    }

    }

?>