# 🦢 Pibvbo
<div align="center"><img src="https://github.com/MC-Alejo/Pibvbo/blob/main/imgs/Pib.png" alt="logo" width="400" height="auto"/></div>


## 📑Descripción

Proyecto originalmente creado con la intención de practicar el patrón de arquitectura de software MVC en PHP.
La idea original se basa en que cada jugador debe responder la mayor cantidad de preguntas correctamente en el menor tiempo posible, para posicionarse entre los mejores del ranking global. En principio se diseñó para que el usuario pueda poner su nombre y unirse a la sala global, dicha sala se borra junto con los jugadores que hayan completado su “día”, cada 24 horas y, se vuelve a crear con nuevas preguntas y sus respuestas, en otras palabras, cada 24 horas los jugadores pueden volver a participar.


## 🤔 ¿Qué conocimientos y experiencias adquiriste durante el desarrollo de este proyecto?

Por lo general, el objetivo era aprender el funcionamiento del patrón MVC, debido a que no llegamos a implementarlo en nuestros proyectos, en la cátedra Programacion Avanzada. Pero esto me sirvió para ampliar los conocimientos en PHP, como también el trabajar en el sistema de gestión de bases de datos MySQL.


## 💻 Tecnologías

<!-- Iconos sacados de: https://github.com/hendrasob/badges/blob/master/README.md y https://github.com/alexandresanlim/Badges4-README.md-Profile -->
[![PHP](https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white)](https://www.php.net/)
[![HTML](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)](https://www.w3.org/html/)
[![CSS](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)](https://www.w3schools.com/css/)


## 🎨 Paleta de colores utilizadas

| Color             | Hex                  |
| ----------------- | ---------------------|
| French mauve | ![#ca61c3](https://via.placeholder.com/10/ca61c3?text=+) #ca61c3 |
| Sunglow | ![#fdca40](https://via.placeholder.com/10/fdca40?text=+) #fdca40 |
| Moonstone | ![#0fa3b1](https://via.placeholder.com/10/0fa3b1?text=+) #0fa3b1 |
| Columbia blue | ![#cee5f2](https://via.placeholder.com/10/cee5f2?text=+) #cee5f2 |


## Vista previa del proyecto

Capturas de pantalla del proyecto:
![Captura del proyecto N1](https://github.com/MC-Alejo/Pibvbo/blob/main/capturas/Captura%20de%20pantalla%201.png?raw=true)
![Captura del proyecto N2](https://github.com/MC-Alejo/Pibvbo/blob/main/capturas/Captura%20de%20pantalla%202.png?raw=true)
![Captura del proyecto N3](https://github.com/MC-Alejo/Pibvbo/blob/main/capturas/Captura%20de%20pantalla%203.png?raw=true)
![Captura del proyecto N4](https://github.com/MC-Alejo/Pibvbo/blob/main/capturas/Captura%20de%20pantalla%204.png?raw=true)


## ✒️ Autor
**Alejo Cabana**
* [LinkedIn](https://www.linkedin.com/in/mc-alejo/)


## ⚠️ Observaciones

* La base de datos es una DEMO, es decir, sólo contiene 135 preguntas con sus respuestas, mientras que la base de datos original completa consta de un total de 900 preguntas. Esto se hizo con la intención de mostrar la estructura y para pruebas. De cualquier manera puedes contactarme si necesitas la BD completa.


## Instalación y Test
Para probar el juego se necesita un sistema gestor de base de datos donde debemos importar nuestro archivo DEMO.sql y un servidor web.
Para este caso, los pasos para probar el juego se detallarán mediante el paquete de software [XAMPP](https://www.apachefriends.org/es/index.html).
- Importar BD utilizando phpMyAdmin:
    * Paso 1: asegúrate de que XAMPP esté instalado y que los servicios Apache y MySQL (o MariaDB) estén en ejecución.
    * Paso 2: abre el navegador y ve a la siguiente dirección: http://localhost/phpmyadmin.
    * Paso 3: crea una nueva base de datos haciendo clic en 'Nueva' en el panel izquierdo. Escribe el nombre de la base de datos que deseas crear, por defecto recomiendo que se llame pibvbo, pero esto no es obligatorio, y luego clic en ‘Crear’
    * Paso 5: selecciona la base de datos en el panel izquierdo de phpMyAdmin.
    * Paso 6: En la pestaña 'Importar', haz clic en 'Examinar' o 'Seleccionar archivo'. Selecciona el archivo DEMO.sql y finalmente haz clic en el botón 'Continuar' o 'Importar'.
- Colocar las carpetas del proyecto en htdocs:
    * Paso 1: Localiza la carpeta htdocs dentro de la carpeta XAMPP, abrela y si es la primera vez que instalas XAMPP, entonces borra todos los archivos de esa carpeta.
    * Paso 2: Copia todos los archivos y carpetas del proyecto en la carpeta.


## ❗IMPORTANTE
Se debe de configurar todos los archivos de la carpeta mvc_mod, con la configuración de la conexión a su base de datos, actualizando la dirección IP, usuario, contraseña y nombre de la base de datos según corresponda, ya que, puede que no coincida con la configuración que se usó en el desarrollo.
Debido a la ausencia de un sistema de inicio de sesión, se utiliza la IP pública de los usuarios para identificarlos como usuarios únicos. Es por ello que, es necesario habilitar los puertos requeridos (suficiente con abrir el puerto 80 para Apache). Dado que el juego no se puede probar a través de la dirección loopback (localhost), se debe de acceder mediante la IP pública (consultable en: https://www.cual-es-mi-ip.net/).


## A futuro
Como el tiempo con el que cuento es muy limitado, y aún faltan pulir, agregar y cambiar bastantes cosas (como actualizar y mejorar el front-end del ranking, optimizar el código, etc), a futuro se desea:
* Agregar que cada jugador pueda crear su sala e invitar a sus amigos a participar.
* Unirse a una sala determinada, por medio de un enlace o un código.
* Agregar ranking semanal o mensual o por región.


## 📄 Licencia
MIT Public License v3.0
No puede usarse comencialmente.
