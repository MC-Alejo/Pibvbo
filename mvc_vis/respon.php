<?php
    
    $respuestas = array(
        $arrayPregunta["respuestacorrecta"],
        $arrayPregunta["respuestaFalsa1"],
        $arrayPregunta["respuestaFalsa2"]
    );

    // Mezcla las respuestas de manera aleatoria
    shuffle($respuestas);

    $body='<div class="Pregunta"><p>'.$arrayPregunta["Pregunta"].'</p></div>
    <div class="respuestas">
    <form action="index.php" method="GET">';

    foreach($respuestas as $respuesta){
        $body.='<button class="botonRespuesta" type="submit" name="RespElejida" value="'.$respuesta.'">'.mb_strtoupper($respuesta).'</button>';
    }

    $body.='
        <input type="hidden" name="Pibv" value="'.$valor.'">
        <input type="hidden" name="Nombre" value="'.$nomSaneado.'" >
        <input type="hidden" name="SalaID" value="'.$salaSaneada.'">
    </form>
    </div>';

    return $body;
?>

