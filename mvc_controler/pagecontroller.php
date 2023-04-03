<?php

if(!empty($_GET['Pibv']))
{

    if(!empty($_GET['Nombre']))
    {
        $nom=$_GET['Nombre'];
        $nomSaneado=Limpieza($_GET['Nombre']);

        if($nom === $nomSaneado)
        {
            if($_GET['Pibv'] === 'Glob')
            {

                if(!empty($_GET['SalaID']))
                {
                    $sala=$_GET['SalaID'];
                    $salaSaneada=Limpieza($_GET['SalaID']);
                    if($sala === $salaSaneada)
                    {
                        if($salaSaneada===hash("sha256",'00000'))
                        {
                            $valor="Glob";
                            if(!empty($_GET['RespElejida']))
                            {
                                $valueShit="GlobalPlay";
                                $resp=$_GET['RespElejida'];

                                require_once('mvc_controler/salacontrol.php');

                                if(isset($arrayRank) AND !empty($arrayRank))
                                {
                                    require_once('mvc_vis/rank.php');

                                }
                                else if(isset($arrayPregunta) AND !empty($arrayPregunta))
                                {    
                                    require_once('mvc_vis/respon.php');
                                }

                            }
                            else
                            {

                                $valueShit="GlobalPlay";

                                require_once('mvc_controler/salacontrol.php');

                                if(!empty($arrayRank))
                                {
                                    require_once('mvc_vis/rank.php');
                                }
                                else if(!empty($arrayPregunta))
                                {    
                                    require_once('mvc_vis/respon.php');
                                }

                            }
                            


                        }
                        
                    }

                }
                else
                {
                    unset($_GET);
                    header("Location: index.php");
                }
        
            }

            }else
            {
                unset($_GET);
                header("Location: index.php");
            }
    }else
    {
    unset($_GET);
    header("Location: index.php");
    }




}
else if(empty($_GET)){
    require_once('mvc_vis/inicio.php');
}
else{
    header("Location: index.php");
}






function Limpieza($cadena)
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




?>