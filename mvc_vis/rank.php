<?php
$body='
<a class="boton" href="index.php">Volver</a>
<h2 class="rank">RANK GLOBAL</h2>';
foreach($arrayRank as $array)
{
    $body.='<div><p>'.$array["nombre"]."-----".$array["puntaje"]."-----".$array["tiempo"].'</p></div>';    
}

return $body;

?>