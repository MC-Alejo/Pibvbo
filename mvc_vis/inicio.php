<?php

$body='<div class="PlayGlobal">
        <h2>JUGAR</h2>
    <form action="index.php" method="GET">
        <h3>Inserte un nombre cualquiera</h3>
        <input class="entrada" name="Nombre" type="text" placeholder="Nombre">
        <input name="SalaID" type="hidden" value="'.hash("sha256","00000").'">
        <button class="boton" type="submit" name="Pibv" value="Glob" >Unirse</button>
    </form>
    </div>';
    return $body;
?>