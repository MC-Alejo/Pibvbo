<?php
require_once('mvc_mod/salamodel.php');

    if(($valueShit==="GlobalPlay") AND (!isset($resp)))
    {
        $SalaGlobal= new Sala();
        $SalaGlobal->setJugadorActual($nom);

        
            if($SalaGlobal->unirseSalaGeneral($salaSaneada))
            {
                $arrayPregunta=$SalaGlobal->ObtenerPreguntasYrespuestas();
            }
            else if($SalaGlobal->ExisteJugadorEnSala())
            {
                if($SalaGlobal->verRanking())
                {
                    $arrayRank=$SalaGlobal->getranking();
                }
                else
                {
                    $arrayPregunta=$SalaGlobal->ObtenerPreguntasYrespuestas();
                }
            }
            else
            {
                unset($_GET);
                $SalaGlobal->cerrarconexion();
                header("Location: index.php");
            }

            $SalaGlobal->cerrarconexion();


    }
    else if($valueShit==="GlobalPlay" AND isset($resp))
    {
        $SalaGlobal= new Sala();
        $SalaGlobal->setJugadorActual($nom);
        if($SalaGlobal->unirseSalaGeneral($salaSaneada))
        {
            $arrayPregunta=$SalaGlobal->ObtenerPreguntasYrespuestas();
        }
        else if($SalaGlobal->ExisteJugadorEnSala())
        {
            $SalaGlobal->calcularTiempototal();
            if($SalaGlobal->verRanking())
            {
                if($SalaGlobal->ComprobarRespElejida($resp))
                {
                    $SalaGlobal->sumarPuntaje();
                    $SalaGlobal->AcumPregRespondidas();
                }
                else
                {
                    $SalaGlobal->AcumPregRespondidas();
                }
                $arrayRank=$SalaGlobal->getranking();
            }
            else
            {

                if($SalaGlobal->ComprobarRespElejida($resp))
                {
                    $SalaGlobal->sumarPuntaje();
                    $SalaGlobal->AcumPregRespondidas();
                }
                else
                {
                    $SalaGlobal->AcumPregRespondidas();
                }
                $SalaGlobal->calcularTiempototal();
                    if($SalaGlobal->verRanking()){
                        $arrayRank=$SalaGlobal->getranking();
                    }else{
                        $arrayPregunta=$SalaGlobal->ObtenerPreguntasYrespuestas();
                    }
            }
        }
        else
        {
            unset($_GET);
            $SalaGlobal->cerrarconexion();
            header("Location: index.php");
        }
        
        
        $SalaGlobal->cerrarconexion();

    }




?>