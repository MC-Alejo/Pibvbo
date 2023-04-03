<?php
class Sala{
    private $id;
    private $juego;

    private $RankingDeLaSala;

    private $jugadorActual;
    private $preguntas_respondidas;
    private $tiempo;
    private $puntaje;

    private $mysqli;

    //constructor
    public function __construct()
    {
        $this->mysqli = new mysqli("localhost","root","","pibvbo");
    }


    //existe la sala?
    public function BuscarSala($SupuestoID)
    {
        if( (!isset($this->id)) AND (!isset($this->juego)))
        {
        
            $this->mysqli->query('SET NAMES gbk');
            $stmt = $this->mysqli->prepare("SELECT ID, IDJuego FROM sala WHERE NOT(ID='00000')");
            $stmt->execute();
            $resultado= $stmt->get_result();
            while($salas = $resultado->fetch_assoc())
            {
                if($SupuestoID === hash("sha256",$salas["ID"]))
                {   
                    $this->id=$salas["ID"];
                    require_once('mvc_mod/juegomodelo.php');
                    $this->juego= new Juego();
                    $this->juego->SetId($salas["IDJuego"]);
                    $this->juego->cargarpreguntas();
                    return true;
                }

            }

            return false;

        }
    }


    // la sala esta llena?
    public function salallena()
    {

        if(isset($this->id))
        {
            $this->mysqli->query('SET NAMES gbk');
            $stmt = $this->mysqli->prepare("SELECT count(IDjugador) as cantidad FROM sala_jugador WHERE idsala=? AND NOT(idsala='00000')");
            $stmt->bind_param('s', $this->id);
            $stmt->execute();
            $resultado= $stmt->get_result();
            $cant=$resultado->fetch_assoc();
            if($cant["cantidad"] > 1)
            {
               return true;
            }

        }

        return false;
    }



    //set jugador actual
    public function setJugadorActual($nombre)
    {
        $nom=$this->Limpieza($nombre);
        require_once('mvc_mod/jugadormod.php');
        $this->jugadorActual= new Jugador($nom);
    }

    //el jugador actual en esta sala existe?
    public function ExisteJugadorEnSala()
    {
        if( (isset($this->id)) AND (isset($this->jugadorActual)) AND (!empty($this->jugadorActual->getID())) )
        {
                $ID=$this->jugadorActual->getID();
                $this->mysqli->query('SET NAMES gbk');
                $stmt = $this->mysqli->prepare("SELECT puntaje, tiempo, preguntas_respondidas FROM sala_jugador WHERE IDsala=? AND IDjugador=?");
                $stmt->bind_param('si', $this->id, $ID);
                $stmt->execute();
                $resultado=$stmt->get_result();
                if($resultado->num_rows > 0)
                {
                    $InfoJugador=$resultado->fetch_assoc();
                    $this->preguntas_respondidas=$InfoJugador["preguntas_respondidas"];
                    $this->puntaje=$InfoJugador["puntaje"];
                    $this->tiempo=$InfoJugador["tiempo"];
                    return true;
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

    //actualizar las preguntas respondidas por el jugador
    public function AcumPregRespondidas()
    {
        if((isset($this->id)) AND (isset($this->jugadorActual)) AND (!empty($this->jugadorActual->getID())) AND ($this->preguntas_respondidas <= 15) AND ($this->preguntas_respondidas >= 0))
        {
            $ID=$this->jugadorActual->getID();
            $this->preguntas_respondidas = $this->preguntas_respondidas + 1;

            $this->mysqli->query('SET NAMES gbk');
            $stmt = $this->mysqli->prepare("UPDATE sala_jugador SET preguntas_respondidas=? WHERE idsala=? AND idjugador = ?");
            $stmt->bind_param('isi', $this->preguntas_respondidas, $this->id, $ID);
            if($stmt->execute())
            {
                return true;
            }
        }
        return false;
    }

    //actualizar el tiempo total del jugador actual
    public function calcularTiempototal()
    {

        if(isset($this->id) AND (isset($this->jugadorActual)) AND (!empty($this->jugadorActual->getID())) )
        {
        if($this->preguntas_respondidas==15)
        {

            $ID=$this->jugadorActual->getID();
            $this->mysqli->query('SET NAMES gbk');
            $stmt = $this->mysqli->prepare("SELECT TIMEDIFF(CURRENT_TIMESTAMP, tiempoUnion) AS tiempo FROM sala_jugador WHERE idsala = ? AND idjugador = ? ");
            $stmt->bind_param('si',$this->id, $ID);
            if($stmt->execute())
            {
            $resultado= $stmt->get_result();
            $JugadorTime=$resultado->fetch_assoc();

            $tiempo=$JugadorTime["tiempo"];
            $this->tiempo=$tiempo;
            $this->AcumPregRespondidas();
            $this->mysqli->query('SET NAMES gbk');
            $stmt = $this->mysqli->prepare("UPDATE sala_jugador SET tiempo=? WHERE idsala=? AND IDJugador=?");
            $stmt->bind_param('ssi', $this->tiempo,$this->id,$ID);
            if($stmt->execute())
            {

                return true;
            }
            }

        }

        }

        return false;
    }

    //sumar puntaje al jugador actual
    public function sumarPuntaje()
    {
        if((isset($this->id)) AND (isset($this->jugadorActual)) AND (!empty($this->jugadorActual->getID())) )
        {
            $ID=$this->jugadorActual->getID();
            $this->puntaje = $this->puntaje + 1;

            $this->mysqli->query('SET NAMES gbk');
            $stmt = $this->mysqli->prepare("UPDATE sala_jugador SET puntaje=? WHERE idsala=? AND idjugador = ?");
            $stmt->bind_param('isi', $this->puntaje, $this->id, $ID);
            if($stmt->execute())
            {
                return true;
            }
        }

        return false;

    }

     //INSERTAR USUARIO EN Sala:
     public  function insertarUsuarioEnSala()
     {
        if((isset($this->id)) AND (isset($this->jugadorActual)) AND (!empty($this->jugadorActual->getID())) )
        {
            if($this->ExisteJugadorEnSala() == false)
            {
                if($this->salallena() == false)
                {
                    $ID=$this->jugadorActual->getID();
                    $this->puntaje=0;
                    $this->preguntas_respondidas=0;
                    $this->tiempo='00:00:00';
                    $this->mysqli->query('SET NAMES gbk');
                    $stmt = $this->mysqli->prepare("INSERT INTO sala_jugador(idsala, idjugador, tiempoUnion, puntaje, tiempo, preguntas_respondidas) VALUES (?,?,CURRENT_TIMESTAMP,?,?,?)");
                    $stmt->bind_param('siisi', $this->id, $ID, $this->puntaje, $this->tiempo, $this->preguntas_respondidas);
                    if($stmt->execute())
                    {
                        return true;
                    }
                    else{
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
         else
         {
            return false;
         }
        
        }


    // Este Usuario Ya creo una sala?
    public function SalaCreadaPorUsuario()
    {
        if(isset($this->jugadorActual) AND (!empty($this->jugadorActual->getID())) )
        {
        $ID=$this->jugadorActual->getID();
        $this->mysqli->query('SET NAMES gbk');
        $stmt = $this->mysqli->prepare("SELECT idsala, IDjugador, min(tiempoUnion) FROM sala_jugador WHERE NOT(idsala='00000') GROUP BY idsala");
        $stmt->execute();
        $resultado=$stmt->get_result();
        while($creador=$resultado->fetch_assoc())
        {
            if($ID==$creador["IDjugador"])
            {
                $this->id=$creador["idsala"];
                return true;
            }

        }
        }
        return false;
    }   


    //crear sala
    public function crearsala()
    {
        if((!isset($this->id)) AND (isset($this->jugadorActual)) AND (!empty($this->jugadorActual->getID())) )
        {
            if($this->SalaCreadaPorUsuario())
            {
                $this->BuscarSala(hash("sha256",$this->id));
                return false;
            }
            else
            {
                $this->mysqli->query('SET NAMES gbk');
                $stmt = $this->mysqli->prepare("SELECT ID FROM sala");
                $stmt->execute();
                $arraySala=array();
                $resultado= $stmt->get_result();
                while($salas = $resultado->fetch_assoc())
                {
                    $arraySala[]=$salas["ID"];
                }

                $band=1;
                while($band==1)
                {
                    $band=0;
                    $IDGenerado = "";
                    $cadena = "123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
                    for ($i = 0; $i < 5; $i++)
                    {
                        $IDGenerado.= $cadena[rand(0,61)];
                    }

                    foreach($arraySala as $value)
                    {

                        if($IDGenerado == $value)
                        {
                            $band=1;
                        }

                    }
        

                }
                                
                

                $this->id=$IDGenerado;
                $this->mysqli->query('SET NAMES gbk');
                $stmt = $this->mysqli->prepare("INSERT INTO sala(ID, fechacreacion) VALUES (?,CURRENT_TIMESTAMP)");
                $stmt->bind_param('s',$IDGenerado);
               if ($stmt->execute())
               {
                    if($this->insertarUsuarioEnSala())
                    {
                        $this->mysqli->query('SET NAMES gbk');
                        $stmt = $this->mysqli->prepare("SELECT IDJuego FROM sala WHERE ID=?");
                        $stmt->bind_param('s',$IDGenerado);
                        if($stmt->execute())
                        {
                            $resultado=$stmt->get_result();
                            $Juego=$resultado->fetch_assoc();
                            require_once('mvc_mod/juegomodelo.php');
                            $this->juego= new Juego();
                            $this->juego->SetId($Juego["IDJuego"]);
                            $this->juego->cargarpreguntas();
                            return true;
                        }

                    }
                    
                }
            }
        }
        
        
        return false;
        

    }

    //Funciones de la sala general:

    //existe la sala GENERAL?
    public function ExisteSalaGeneral()
    {
        if($this->id=='00000')
        {
        $this->mysqli->query('SET NAMES gbk');
        $stmt= $this->mysqli->prepare("SELECT IDJuego FROM sala WHERE ID='00000'");
        $stmt->execute();
        $resultado=$stmt->get_result();
            if($resultado->num_rows > 0)
            {
                $juegosala=$resultado->fetch_assoc();
                require_once('mvc_mod/juegomodelo.php');
                $this->juego= new Juego();
                $this->juego->SetId($juegosala["IDJuego"]);
                $this->juego->cargarpreguntas();
                return true;
            }
        }
        return false;
    }

    //unirse a la sala general
    public function unirseSalaGeneral($SupuestoID)
    {
        if( (isset($this->jugadorActual)) AND (!empty($this->jugadorActual->getID())) )
        {
            if($SupuestoID == hash("sha256",'00000'))
            {
                $this->id='00000';

                if($this->ExisteSalaGeneral())
                {

                    if($this->insertarUsuarioEnSala() == true)
                    {
                        return true;
                    }
                }
                
            }
    
        }

        return false;
    }

    //Consultar Ranking de la sala

    public function verRanking(){
        if( (isset($this->id)) AND (isset($this->juego)) AND(isset($this->jugadorActual)) AND (!empty($this->jugadorActual->getID())))
        {
            if((isset($this->preguntas_respondidas)) and ($this->preguntas_respondidas > 15))
            {   
                $this->mysqli->query('SET NAMES gbk');
                $stmt = $this->mysqli->prepare("SELECT j.nombre, sj.puntaje, sj.tiempo FROM jugador j INNER JOIN sala_jugador sj ON j.ID=sj.idjugador WHERE idsala=?");
                $stmt->bind_param('s',$this->id);
                if($stmt->execute())
                {
                    $resultado=$stmt->get_result();
                    if($resultado->num_rows > 0)
                    {
                        $this->RankingDeLaSala=array();
                        while($PuntuacionUsuario=$resultado->fetch_assoc())
                        {
                            $puntuacion["nombre"]=$PuntuacionUsuario["nombre"];
                            $puntuacion["puntaje"]=$PuntuacionUsuario["puntaje"];
                            $puntuacion["tiempo"]=$PuntuacionUsuario["tiempo"];
                            array_push($this->RankingDeLaSala,$puntuacion);
                        }
                        return true;
                    }
                
                }
            
            }

        }
        return false;
    }

    //get ranking:
    public function getranking()
    {
        return $this->RankingDeLaSala;
    }


    //LIMPIADOR de cadenas
    public function Limpieza($cadena)
    {
    $cadenaLimpia= str_replace(" ","",$cadena); // 
    $cadenaLimpia=filter_var($cadenaLimpia,FILTER_SANITIZE_ENCODED,FILTER_FLAG_ENCODE_HIGH);
    $cadenaLimpia=htmlspecialchars($cadenaLimpia);
    $cadenaLimpia= str_replace("%","",$cadenaLimpia);
    $cadenaLimpia= str_replace("_","",$cadenaLimpia);
    $cadenaLimpia=preg_replace('([^A-Za-z0-9])','', $cadenaLimpia);
    $cadenaLimpia=preg_replace('/[\W]/','', $cadenaLimpia);
    return $cadenaLimpia;
    }

    //get pregunta:
    public function ObtenerPreguntasYrespuestas()
    {
            $PyR["Pregunta"]=$this->juego->extraerPregunta($this->preguntas_respondidas);
            $PyR["respuestacorrecta"]=$this->juego->extraerRespuestaCorrecta($this->preguntas_respondidas);
            $PyR["respuestaFalsa1"]=$this->juego->extraerRespuestaFalsa1($this->preguntas_respondidas);
            $PyR["respuestaFalsa2"]=$this->juego->extraerRespuestaFalsa2($this->preguntas_respondidas);
            return $PyR;
    }

    public function ComprobarRespElejida($respuesta)
    {
        if($respuesta===$this->juego->extraerRespuestaCorrecta($this->preguntas_respondidas)){
           return true;
        }
        else{
            return false;
        }
    }


    //cerrar conexion a la bd:

    public function cerrarconexion()
    {
        if(isset($this->jugadorActual)){
            $this->jugadorActual->cerrarconexion();    
        }
        if(isset($this->juego)){
            $this->juego->cerrarconexion();
        }

        
        $this->mysqli->close();

    }   

}



?>