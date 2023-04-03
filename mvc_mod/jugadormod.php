<?php

use LDAP\Result;

class Jugador{
    private $id;
    private $nombre;
    private $IPPublic;
    private $IPLAN;
    private $navegador;
    private $Pais;

    private $mysqli;


    public function __construct($nombre)
    {
        $this->mysqli = new mysqli("localhost","root","","pibvbo");

        if($this->SetAutoData())
        {
            if($this->Verfexistencia())
            {
            $this->mysqli->query('SET NAMES gbk');
            $stmt = $this->mysqli->prepare("SELECT nombre FROM jugador WHERE ID=?");
            $stmt->bind_param('i', $this->id);
                if($stmt->execute())
                {
                    $resultado=$stmt->get_result();
                    $Jugador= $resultado->fetch_assoc();
                    $this->nombre=$Jugador["nombre"];
                }
            }  
            else
            {
                $this->nombre=$nombre;
                $this->InsertarEnDB();
            }
        }

    }

    //los gets
    public function getNAME(){
        return $this->nombre;
    }

    public function getID()
    {
        return $this->id;
    }

    //SETS DE LOS DATOS DEL JUGADOR
    public function SetAutoData()
    {
        $IP=$_SERVER['REMOTE_ADDR'];
        if(filter_var($IP, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE) !== false)
        {
            $PublicIP=$IP;
            $IPLAN=$this->getUserIpAddress();
            if($IPLAN!=='?')
            {
                $this->IPPublic=$PublicIP;
                $this->IPLAN=$IPLAN;

                $nav= $_SERVER['HTTP_USER_AGENT'];
                $nav=$this->Limpieza($nav);
                
                $this->navegador=$nav;
                if(!empty($nav))
                {

                    $json = file_get_contents("http://ipinfo.io/$PublicIP/geo");
                    $json = json_decode($json, true);
                    $json = $this->Limpieza($json['country']);
                    if(!empty($json)){
                        $this->Pais= $json;
                        return true;
                    }
                }
            }
        }
        
        return false;

    }

    //Insertar usuario en DB:
    public function InsertarEnDB()
    {
        if((!isset($this->id)) AND (!empty($this->nombre)) AND (!empty($this->IPPublic)) AND (!empty($this->IPLAN)) AND (!empty($this->navegador)) AND (!empty($this->Pais)))
        {
            $this->mysqli->query('SET NAMES gbk');
            $stmt = $this->mysqli->prepare("SELECT max(ID) as mam from jugador");
            $stmt->execute();
            $resul1=$stmt->get_result();
            $maximo=$resul1->fetch_assoc();

            $this->mysqli->query('SET NAMES gbk');
            $stmt2= $this->mysqli->prepare("SELECT min(ID) as mim from jugador");
            $stmt2->execute();
            $resul2=$stmt2->get_result();
            $minimo=$resul2->fetch_assoc();
        

            $max=$maximo["mam"];
            $min=$minimo["mim"];

            if(empty($max))
            {
                $this->id=1;
            }
            elseif (($min!=1) AND ($min>0))
            {
                $this->id=$min-1;
            }
            else
            {
                $this->id=$max+1;
            }

                $this->mysqli->query('SET NAMES gbk');
                $stmt = $this->mysqli->prepare("INSERT INTO jugador VALUES(?, ?, ?, ?, ?, ?)");
                $stmt->bind_param('isssss', $this->id, $this->nombre, $this->IPPublic, $this->IPLAN, $this->navegador, $this->Pais);
                $stmt->execute();
                return true;

            }
        else
        {
            return false;
        }
    }
    

    //funcion que devuelve la ip con seguridad:
    public function getUserIpAddress()
    {

        foreach ( [ 'HTTP_CLIENT_IP', 'HTTP_X_FORWARDED_FOR', 'HTTP_X_FORWARDED', 'HTTP_X_CLUSTER_CLIENT_IP', 'HTTP_FORWARDED_FOR', 'HTTP_FORWARDED', 'REMOTE_ADDR' ] as $key ) {
    
            // Comprobamos si existe la clave solicitada en el array de la variable $_SERVER 
            if ( array_key_exists( $key, $_SERVER ) )
            {
    
                // Eliminamos los espacios blancos del inicio y final para cada clave que existe en la variable $_SERVER 
                foreach ( array_map('trim',explode(',', $_SERVER[$key])) as $IPV4)
                {
    
                    // Filtramos* la variable y retorna el primero que pase el filtro
                    if ( filter_var($IPV4, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE) !== false )
                    {
                        return $IPV4;
                    }
                }
                }
            }
    
        return '?'; // Retornamos '?' si no hay ninguna IP o no pase el filtro
    }

    public function Verfexistencia()
    {
        if(!empty($this->IPPublic))
        {
            $this->mysqli->query('SET NAMES gbk');
            $stmt = $this->mysqli->prepare("SELECT ID as IDjugador FROM jugador WHERE IPPublic= ?  AND IPLAN= ? AND Pais= ?");
            $stmt->bind_param('sss', $this->IPPublic, $this->IPLAN, $this->Pais);
            $stmt->execute();
            $resultado = $stmt->get_result();
            if($resultado->num_rows > 0){
                $IDresult= $resultado->fetch_assoc();
                $this->id=$IDresult["IDjugador"];
                return true;
            }
            else
            {
                return false;
            }
            
        }
        else{
            return false;
        }
    }

    //limpiador de cadena
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


   
    public function cerrarconexion()
    {
        
        $this->mysqli->close();
        
    }


}
?>