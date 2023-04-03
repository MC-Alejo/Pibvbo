-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 02-04-2023 a las 09:21:45
-- Versión del servidor: 10.4.27-MariaDB
-- Versión de PHP: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `pibvbo`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ADiario` ()   BEGIN
DECLARE IDgame int;

SELECT IDJuego INTO IDgame FROM sala WHERE ID = '00000';

IF IDgame IS NULL THEN
	INSERT INTO `sala`(`ID`, `fechacreacion`) VALUES('00000',CURRENT_TIMESTAMP);
ELSE
	DELETE FROM juego WHERE ID=IDgame;
	INSERT INTO `sala`(`ID`, `fechacreacion`) VALUES('00000',CURRENT_TIMESTAMP);
END IF;

CALL borrar_jugadoresSinSala();

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `borrar_jugadoresSinSala` ()   BEGIN
DECLARE registroid int;
    DECLARE listo BOOLEAN DEFAULT FALSE;
	DECLARE jugadores CURSOR FOR SELECT j.ID FROM jugador j LEFT JOIN sala_jugador sj ON sj.idjugador=j.ID WHERE sj.idsala is null;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET listo = TRUE;
    
	OPEN jugadores;
    
    simple_loop: LOOP
    FETCH jugadores INTO registroid;
    IF listo THEN
    	LEAVE simple_loop;
    END IF;
    DELETE FROM jugador WHERE ID = registroid;
    END LOOP;
    
    CLOSE jugadores;





END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_Juego` (IN `ID_asignado` INT)   BEGIN
	DECLARE categoria1 varchar(2);
    DECLARE categoria2 varchar(2);
    DECLARE categoria3 varchar(2);
    DECLARE categoria4 varchar(2);
    DECLARE categoria5 varchar(2);
    DECLARE i int;
    
    DECLARE preguntanum1 int;
    DECLARE preguntanum2 int;
    DECLARE preguntanum3 int;

    SELECT generarcategoria() into categoria1;
    WHILE categoria5 IS NULL DO
     	IF categoria2 IS NULL THEN
        		SELECT generarcategoria() into categoria2;
           		IF categoria2 = categoria1 THEN 
                	SET categoria2 = null;
        		end if;
        ELSEIF categoria3 IS NULL THEN
      			SELECT generarcategoria() into categoria3;
                IF categoria3 = categoria2 OR categoria3 = categoria1 THEN 
                	SET categoria3 = null;
        		end if;
        ELSEIF categoria4 IS NULL THEN
      			SELECT generarcategoria() into categoria4;
                IF categoria4 = categoria3 OR categoria4 = categoria2 OR categoria4 = categoria1 THEN 
                	SET categoria4 = null;
        		end if;
        ELSE
      			SELECT generarcategoria() into categoria5;
                IF categoria5 = categoria4 OR categoria5 = categoria3 OR categoria5 = categoria2 OR categoria5 = categoria1 THEN 
                	SET categoria5 = null;
        		end if;
         END IF;
	END WHILE;
    
    SET i = 0;
    
	WHILE i<5 DO
    
    SET preguntanum1 = 0;
    SET preguntanum2 = 0;
    SET preguntanum3 = 0;

    	WHILE preguntanum3 = 0 DO
        	IF preguntanum1 = 0 THEN
           		SELECT FLOOR(1 + RAND()*(15 - 1 + 1)) INTO preguntanum1;
            ELSEIF preguntanum2 = 0 THEN
            	SELECT FLOOR(1 + RAND()*(15 - 1 + 1)) INTO preguntanum2;
                IF preguntanum2 = preguntanum1 THEN
                	SET preguntanum2 = 0;
                END IF;
            ELSE
            	SELECT FLOOR(1 + RAND()*(15 - 1 + 1)) INTO preguntanum3;
            	IF preguntanum3 = preguntanum2 OR preguntanum3 = preguntanum1 THEN
                	SET preguntanum3 = 0;
                END IF;
            END IF;
        END WHILE;
        
        IF i=0 THEN
        	INSERT INTO juego_contiene_preguntas VALUES(ID_asignado, (SELECT ID from pregunta WHERE categoria = categoria1 AND num = preguntanum1));
            INSERT INTO juego_contiene_preguntas VALUES(ID_asignado, (SELECT ID from pregunta WHERE categoria = categoria1 AND num = preguntanum2));
            INSERT INTO juego_contiene_preguntas VALUES(ID_asignado, (SELECT ID from pregunta WHERE categoria = categoria1 AND num = preguntanum3));
        ELSEIF i=1 THEN
            INSERT INTO juego_contiene_preguntas VALUES(ID_asignado, (SELECT ID from pregunta WHERE categoria = categoria2 AND num = preguntanum1));
            INSERT INTO juego_contiene_preguntas VALUES(ID_asignado, (SELECT ID from pregunta WHERE categoria = categoria2 AND num = preguntanum2));
            INSERT INTO juego_contiene_preguntas VALUES(ID_asignado, (SELECT ID from pregunta WHERE categoria = categoria2 AND num = preguntanum3));
        ELSEIF i=2 THEN
             INSERT INTO juego_contiene_preguntas VALUES(ID_asignado, (SELECT ID from pregunta WHERE categoria = categoria3 AND num = preguntanum1));
            INSERT INTO juego_contiene_preguntas VALUES(ID_asignado, (SELECT ID from pregunta WHERE categoria = categoria3 AND num = preguntanum2));
            INSERT INTO juego_contiene_preguntas VALUES(ID_asignado, (SELECT ID from pregunta WHERE categoria = categoria3 AND num = preguntanum3));
        ELSEIF i=3 THEN
            INSERT INTO juego_contiene_preguntas VALUES(ID_asignado, (SELECT ID from pregunta WHERE categoria = categoria4 AND num = preguntanum1));
            INSERT INTO juego_contiene_preguntas VALUES(ID_asignado, (SELECT ID from pregunta WHERE categoria = categoria4 AND num = preguntanum2));
            INSERT INTO juego_contiene_preguntas VALUES(ID_asignado, (SELECT ID from pregunta WHERE categoria = categoria4 AND num = preguntanum3));
        ELSE 
            INSERT INTO juego_contiene_preguntas VALUES(ID_asignado, (SELECT ID from pregunta WHERE categoria = categoria5 AND num = preguntanum1));
            INSERT INTO juego_contiene_preguntas VALUES(ID_asignado, (SELECT ID from pregunta WHERE categoria = categoria5 AND num = preguntanum2));
            INSERT INTO juego_contiene_preguntas VALUES(ID_asignado, (SELECT ID from pregunta WHERE categoria = categoria5 AND num = preguntanum3));
        end if;
    SET i=i+1;
    END WHILE;
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `generarcategoria` () RETURNS VARCHAR(2) CHARSET utf8mb4 COLLATE utf8mb4_general_ci NO SQL BEGIN
DECLARE ran int;
SELECT FLOOR(1 + RAND()*(9 - 1 + 1)) INTO ran;
CASE ran
WHEN 1 THEN RETURN 'A';
WHEN 2 THEN RETURN 'B';
WHEN 3 THEN RETURN 'C';
WHEN 4 THEN RETURN 'CG';
WHEN 5 THEN RETURN 'D';
WHEN 6 THEN RETURN 'E';
WHEN 7 THEN RETURN 'G';
WHEN 8 THEN RETURN 'H';
WHEN 9 THEN RETURN 'M';
ELSE RETURN 'A';
END CASE;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `juego`
--

CREATE TABLE `juego` (
  `ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `juego`
--

INSERT INTO `juego` (`ID`) VALUES
(1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `juego_contiene_preguntas`
--

CREATE TABLE `juego_contiene_preguntas` (
  `idjuego` int(11) DEFAULT NULL,
  `idpregunta` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `juego_contiene_preguntas`
--

INSERT INTO `juego_contiene_preguntas` (`idjuego`, `idpregunta`) VALUES
(1, 'Q101'),
(1, 'Q103'),
(1, 'Q108'),
(1, 'Q703'),
(1, 'Q705'),
(1, 'Q714'),
(1, 'Q612'),
(1, 'Q602'),
(1, 'Q604'),
(1, 'Q15'),
(1, 'Q13'),
(1, 'Q5'),
(1, 'Q501'),
(1, 'Q504'),
(1, 'Q503');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jugador`
--

CREATE TABLE `jugador` (
  `ID` int(11) NOT NULL,
  `nombre` varchar(20) DEFAULT NULL,
  `IPPublic` varchar(40) NOT NULL,
  `IPLAN` varchar(40) NOT NULL,
  `navegador` varchar(120) DEFAULT NULL,
  `pais` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pregunta`
--

CREATE TABLE `pregunta` (
  `ID` varchar(10) NOT NULL,
  `categoria` varchar(2) NOT NULL,
  `num` int(11) DEFAULT NULL,
  `preg` varchar(250) DEFAULT NULL,
  `correcta` varchar(100) DEFAULT NULL,
  `falsa1` varchar(100) DEFAULT NULL,
  `falsa2` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pregunta`
--

INSERT INTO `pregunta` (`ID`, `categoria`, `num`, `preg`, `correcta`, `falsa1`, `falsa2`) VALUES
('Q1', 'M', 1, '¿A cuánto equivale π (Pi)?', '3,141592', '3,151515', '3,16'),
('Q10', 'M', 10, '¿Cuántos meses tiene un trimestre?', '3 meses', '9 meses', '6 meses'),
('Q101', 'CG', 1, '¿Cuáles de estos no forma parte de los cinco tipos de sabores primarios?', 'Hierro', 'dulce', 'umami'),
('Q102', 'CG', 2, '¿Cuál es el lugar más frío de la tierra?', 'La Antártida', 'Canadá', 'África'),
('Q103', 'CG', 3, '¿Cómo se llama la Reina del Reino Unido?', 'Isabel II', 'Isabel III', 'Isabel VI'),
('Q104', 'CG', 4, '¿Dónde originaron los juegos olímpicos?', 'Grecia', 'Roma', 'Italia'),
('Q105', 'CG', 5, '¿Dónde se encuentra la Sagrada Familia?', 'Barcelona', 'Madrid', 'Rumanía'),
('Q106', 'CG', 6, '¿En qué se especializa la cartografía?', 'los mapas', 'los cartones', 'los dibujos'),
('Q107', 'CG', 7, '¿Qué país tiene forma de bota?', 'Italia', 'España', 'Francia'),
('Q108', 'CG', 8, '¿Cuál es la moneda del Reino Unido?', 'La libra', 'El Peso', 'La Peseta'),
('Q109', 'CG', 9, '¿Cual es país más poblado de la Tierra?', 'China', 'Estados Unidos', 'Rusia'),
('Q11', 'M', 11, '¿Cuánto es un lustro?', '5 años', '10 años', '15 años'),
('Q110', 'CG', 10, '¿Cuál es el color que representa la esperanza?', 'verde', 'azul', 'Ninguno de ellos'),
('Q111', 'CG', 11, '¿Con qué se fabricaba el pergamino?', 'piel de animales', 'piel de humanos', 'piel de dinosaurios'),
('Q112', 'CG', 12, '¿Cuál es la ciudad de los rascacielos?', 'Nueva York', 'Tokio', 'Singapur'),
('Q113', 'CG', 13, '¿En qué país se encuentra el famoso monumento Taj Mahal?', 'India', 'Turquía', 'Brasil'),
('Q114', 'CG', 14, '¿Cuál es el nombre de la lengua oficial en china?', 'mandarín', 'Naranjin', 'Inglés'),
('Q115', 'CG', 15, '¿Cómo le llaman a los textos de autores desconocidos?', 'Anónimo', 'seudónimo', 'Mito'),
('Q12', 'M', 12, '¿Qué es un polígono regular?', 'El que tiene sus lados y ángulos interiores iguales', 'El que tiene sus lados y ángulos interiores desiguales', 'Ninguna de las Anteriores'),
('Q13', 'M', 13, '¿Qué cantidad expresa el número romano I?', '1', '2', '3'),
('Q14', 'M', 14, '¿Qué cantidad expresa el número romano II?', '2', '3', '4'),
('Q15', 'M', 15, '¿Qué cantidad expresa el número romano III?', '3', '4', '5'),
('Q2', 'M', 2, '¿Qué fórmula sirve para calcular el área de un círculo?', 'π x R²', 'π / R²', 'π - R²'),
('Q201', 'G', 1, '¿Cuál es el océano más grande del mundo?', 'Pacífico', 'Atlántico', 'Antártico'),
('Q202', 'G', 2, '¿Cuál de estos NO es un continente del planeta Tierra?', 'Estados Unidos', 'Europa', 'América'),
('Q203', 'G', 3, '¿Cuál es el país más pequeño del mundo?', 'El Vaticano', 'Australia', 'Haití'),
('Q204', 'G', 4, '¿Cual es el nombre del desierto más grande del mundo?', 'Sahara', 'Sajara', 'Sara'),
('Q205', 'G', 5, '¿Cuántos océanos hay en la Tierra?', '5', '3', '7'),
('Q206', 'G', 6, '¿Qué país es el más grande del mundo?', 'Rusia', 'Canadá', 'Estados Unidos'),
('Q207', 'G', 7, '¿Cuál es la montaña más alta del mundo?', 'Monte Everest', 'El Aconcagua', 'Kanchenjunga'),
('Q208', 'G', 8, '¿Cuál es el río más largo del mundo?', 'Amazonas', 'Nilo', 'El Tajo'),
('Q209', 'G', 9, '¿Cuál es la montaña más alta de España?', 'El Teide', 'El Aconcagua', 'El Monte Everest'),
('Q210', 'G', 10, '¿Cuántos estados forman parte de Estados Unidos?', '50', '40', '30'),
('Q211', 'G', 11, '¿Que es el mar muerto?', 'Un Lago', 'Una Montaña', 'Un Mar'),
('Q212', 'G', 12, '¿Cual de estos países se encuentra entre dos continentes?', 'Turquía', 'Francia', 'Ucrania'),
('Q213', 'G', 13, '¿En cuál océano desemboca el río Amazonas?', 'Atlántico', 'Antártico', 'Pacífico'),
('Q214', 'G', 14, '¿Cuál es el nombre de la cordillera de montañas más larga del mundo?', 'Los Andes', 'Los Aires', 'Los Ombues'),
('Q215', 'G', 15, '¿Qué país cuenta con un mayor número de volcanes?', 'Estados Unidos', 'Nicaragua', 'México'),
('Q3', 'M', 3, '¿Qué expresa esta fórmula? e = mc²', 'La equivalencia entre la masa y la energía', 'la teoría de la probabilidad', 'Circunferencia de un círculo'),
('Q301', 'H', 1, '¿En qué año llegó el hombre a la Luna?', '1969', '1968', '1970'),
('Q302', 'H', 2, '¿Qué importante batalla tuvo lugar en 1815? La Batalla de…', 'Waterloo', 'Watermoon', 'Moonloo'),
('Q303', 'H', 3, ' ¿Qué evento desencadenó la Primera Guerra Mundial?', 'un asesinato', 'una revolución', 'Ninguna de las Anteriores'),
('Q304', 'H', 4, ' ¿Quién fue el primer presidente de Estados Unidos?', 'G. Washington', 'T. Jefferson', 'B. Obama'),
('Q305', 'H', 5, '¿Cuánto duró la Guerra de los Cien Años?', '116', '50', '120'),
('Q306', 'H', 6, '¿Cómo se conocía la Primera Guerra Mundial antes de que estallara la segunda?', 'La Gran Guerra', 'La Primera De Muchas', 'La primera'),
('Q307', 'H', 7, '¿Qué batalla marítima tuvo lugar en el año 1805? La Batalla de...', 'Trafalgar', 'Tribunal', 'Trabalgar'),
('Q308', 'H', 8, '¿Cuál era la moneda utilizada en España antes del euro?', 'La Peseta', 'El Peso Español', 'La Libra'),
('Q309', 'H', 9, '¿En qué año llegó Cristóbal Colón a América por primera vez?', '1492', '1493', '1495'),
('Q310', 'H', 10, '¿Cuáles fueron los últimos dos países que lograron la independencia de España a finales del siglo XIX?', 'Cuba y Puerto Rico', 'Cuba y Argentina', 'Argentina y Puerto Rico'),
('Q311', 'H', 11, 'La frase Maldito sea el soldado que vuelva las armas contra su pueblo la dijo…', 'Simón Bolívar', 'José de San Martín', 'Rafael Caldera'),
('Q312', 'H', 12, '¿En qué país falleció el general José de San Martín?', 'Francia', 'Argentina', 'España'),
('Q313', 'H', 13, '¿En qué isla encarcelaron a Napoleón tras perder la batalla de Waterloo?', 'Santa Elena', 'Santa Maria', 'Maria Elena'),
('Q314', 'H', 14, '¿Cómo se llamaban los hijos de españoles nacidos en los territorios colonizados?', 'Criollos', 'Mulatos', 'Mestizos'),
('Q315', 'H', 15, '¿Quién de estos mandatarios ha permanecido más tiempo en el poder?', 'Fidel Castro', 'Nicolás Maduro', 'Néstor Kirchner'),
('Q4', 'M', 4, '¿Qué cantidad expresa el número romano V?', '5', '10', '20'),
('Q401', 'C', 1, '¿Qué animal utilizó el Premio Nobel de medicina Ivan Pavlov en sus experimentos?', 'Perros', 'Roedores', 'Gatos'),
('Q402', 'C', 2, 'Que animales evolucionaron a partir de los dinosaurios', 'Las aves', 'Los murciélagos', 'los monos'),
('Q403', 'C', 3, '¿En qué galaxia se encuentra la Tierra?', 'Vía Láctea', 'Can Mayor', 'Andrómeda'),
('Q404', 'C', 4, '¿Cuál es la fórmula química del agua?', 'H2O', 'HO', 'O2'),
('Q405', 'C', 5, '¿Cuál es el único satélite natural de la Tierra?', 'La luna', 'el sol', 'marte'),
('Q406', 'C', 6, '¿Cuál es la edad del universo? (Aproximadamente)', '14.000 millones de años', '8.000 millones de años', '2.000 millones de años'),
('Q407', 'C', 7, '¿Que pasaria si la Tierra dejase de girar?', 'saldríamos “disparados”', 'Nada, sigue todo normal', 'nos quedamos quietos'),
('Q408', 'C', 8, '¿Cual de estos es el dinosaurio más grande que existió?', 'Patagotitan mayorum', 'Tiranosaurio rex', 'Velociraptor'),
('Q409', 'C', 9, '¿Cómo se llama a la muerte de cada miembro de una especie? ', 'Extinción', 'Redención', 'Exilio'),
('Q410', 'C', 10, '¿Cuál es el planeta más cercano al Sol?', 'Mercurio', 'Marte', 'La Tierra'),
('Q411', 'C', 11, '¿Qué carga lleva un electrón?', 'negativa', 'Positiva', 'Neutra'),
('Q412', 'C', 12, '¿Cuál es el primer elemento de la tabla periódica?', 'hidrógeno', 'Oxígeno', ' Nitrógeno'),
('Q413', 'C', 13, '¿Qué biólogo propuso la teoría de la evolución?', 'Charles Darwin', 'Thomas Alva Edison', 'Nikola Tesla'),
('Q414', 'C', 14, '¿Cual de estos no es un planeta?', 'Andrómeda', 'Saturno', 'Marte'),
('Q415', 'C', 15, '¿Cuál de estos tres NO es un estado de la materia?', 'blando', 'gaseoso', 'líquido'),
('Q5', 'M', 5, '¿Cuál es el número anterior a 1000?', '999', '900', '990'),
('Q501', 'A', 1, '¿Quién escribió la Ilíada y la Odisea?', 'Homero', 'Hesíodo', 'Píndaro'),
('Q502', 'A', 2, '¿Qué novela importante de la literatura española y universal escribió Miguel de Cervantes?', 'Don Quijote de la Mancha', 'Tirante el Blanco', 'El asno de oro'),
('Q503', 'A', 3, '¿Qué gran artista es conocido por haber pintado la Capilla Sixtina?', 'Miguel Ángel', 'Vincent van Gogh', 'Pablo Picasso'),
('Q504', 'A', 4, '¿Quién pintó el “Guernica”?', 'Pablo Picasso', 'Vincent van Gogh', 'Miguel Ángel'),
('Q505', 'A', 5, '¿De qué estilo arquitectónico es la catedral de Notre Dame?', 'Gótico', 'moderno', 'contemporáneo'),
('Q506', 'A', 6, '¿De qué obra de Shakespeare forma parte el soliloquio “Ser o no ser, esa es la cuestión”?', 'Hamlet', 'Romeo y Julieta', 'Macbeth'),
('Q507', 'A', 7, '¿Quién escribió “La colmena”?', 'Camilo José Cela', 'Miguel Delibes', 'Carmen Laforet'),
('Q508', 'A', 8, '¿Qué nombre tenía el caballo de Don Quijote de la Mancha?', 'Rocinante', 'Tornado', 'Pamperito'),
('Q509', 'A', 9, '¿De qué país es originario el tipo de poesía conocido como haiku?', 'Japón', 'India', 'Singapur'),
('Q510', 'A', 10, '¿Qué escritor hispanoparlante recibió el apodo de “el manco de Lepanto”?', 'Miguel de Cervantes', 'Gabriel García Márquez', 'Jorge Luis Borges'),
('Q511', 'A', 11, '¿Qué animal mitológico da nombre a uno de los libros más conocidos de Thomas Hobbes?', 'La bestia marina Leviatán', 'El Centauro', 'Ninguno de ellos'),
('Q512', 'A', 12, '¿Cómo se llama el famoso psicólogo estadounidense autor del libro “Más allá de la libertad y la dignidad”?', 'B. F. Skinner', 'H. Gardner', 'W. James'),
('Q513', 'A', 13, '¿Cómo se llama el pintor noruego autor de la obra “El Grito”?', 'Edvard Munch', 'Vincent van Gogh', 'Salvador Dalí'),
('Q514', 'A', 14, ' ¿En qué otro idioma, además del castellano, escribió la novelista y poetisa Rosalía de Castro?', 'Gallego', 'Francés', 'Inglés'),
('Q515', 'A', 15, '¿Qué personaje del universo literario de Harry Potter tiene una rata llamada Scabbers?', 'Ron Weasley', 'Harry Potter', 'Hermione Granger'),
('Q6', 'M', 6, '¿Cómo se llama el polígono de siete lados?', 'Heptágono', 'Sieteágono', 'Septágono'),
('Q601', 'B', 1, '¿Cómo se llaman los orgánulos celulares de la planta donde se lleva a cabo la fotosíntesis?', 'Cloroplastos', 'Citoplasma', 'Tallo'),
('Q602', 'B', 2, '¿Qué músculo impulsa la sangre por todo nuestro cuerpo?', 'El corazón', 'El cerebro', 'Los pulmones'),
('Q603', 'B', 3, '¿Qué necesitan las células para dividirse?', 'Energía', 'Otra célula', 'Ninguna de las Anteriores'),
('Q604', 'B', 4, '¿Cómo se llama el pigmento verde que se encuentra en las plantas?', 'Clorofila', 'Colorfila', 'Citrofila'),
('Q605', 'B', 5, '¿Cuál es el denominado “fluido vital”, imprescindible en los seres vivos?', 'Agua', 'Gaseosa', 'Vodka'),
('Q606', 'B', 6, '¿Cuál es el nombre de la sustancia gelatinosa que está dentro de la célula?', 'Citoplasma', 'Mitocondria', 'Ribosoma'),
('Q607', 'B', 7, '¿Mediante qué molécula se transmite la información genética de generación en generación?', 'ADN', 'ANN', 'DNN'),
('Q608', 'B', 8, 'Para la Zoología ¿Cómo se llama la modificación que viven ciertos animales mientras crecen y se desarrollan, donde pueden cambiar de forma e incluso de género?', 'Metamorfosis', 'mitosis', 'Metabolismo'),
('Q609', 'B', 9, '¿Qué clase del reino animal poseen respiración branquial durante la fase larvaria y pulmonar al alcanzar el estado adulto?', 'anfibios', 'moluscos', 'gusanos'),
('Q610', 'B', 10, '¿Cuál de estos elementos no forma parte de los cuatro elementos básicos de la materia de los seres vivos?', 'Mercurio', 'Oxígeno', 'carbono'),
('Q611', 'B', 11, '¿Cuál es el propósito de las mitocondrias en las células vegetales y animales?', 'Crean energía', 'Buscan los virus', 'producen la adrenalina'),
('Q612', 'B', 12, '¿Qué clase del reino animal poseen glándulas mamarias?', 'mamíferos', 'anfibios', 'aves'),
('Q613', 'B', 13, '¿Qué sistema se encarga de conducir la sangre a todos los tejidos del organismo humano?', 'cardiovascular', 'respiratorio', 'digestivo'),
('Q614', 'B', 14, '¿Qué contienen los cloroplastos de las células vegetales?', 'Clorofila', 'Agua', 'Metamorfosis'),
('Q615', 'B', 15, '¿Cuál de estos tipos de células es el que posee una membrana celular?', 'ambas', 'células animales', 'células vegetales'),
('Q7', 'M', 7, '¿Cuál es el nombre del triángulo que tiene dos lados iguales y uno desigual?', 'isósceles', 'escaleno', 'equilátero'),
('Q701', 'D', 1, '¿Cuánto dura en total un partido de fútbol?', '90 minutos', '80 minutos', '20 minutos'),
('Q702', 'D', 2, '¿Cuándo se celebró el primer mundial de fútbol?', '13 de julio de 1930', '13 de julio de 1920', '13 de julio de 1940'),
('Q703', 'D', 3, '¿Qué selección de fútbol ha ganado más Mundiales?', 'Brasil', 'Argentina', 'Alemania'),
('Q704', 'D', 4, '¿En qué provincia se encuentra el estadio popularmente conocido como La Bombonera?', 'Buenos Aires', 'Rosario', 'Entre Ríos'),
('Q705', 'D', 5, '¿Cuál es el apodo del Leicester City?', 'The Foxes', 'The Dogs', 'The Fifes'),
('Q706', 'D', 6, '¿En cuántos minutos está repartida la duración de un partido de fútbol?', '45 minutos', '35 minutos', '40 minutos'),
('Q707', 'D', 7, '¿Cuánto dura la prórroga en un partido de fútbol, según el reglamento?', '30 minutos (15+15)', '20 minutos (10+10)', '8 minutos (4+4)'),
('Q708', 'D', 8, '¿Cuántos jugadores tiene un equipo de fútbol en el campo de juego?', '11', '15', '5'),
('Q709', 'D', 9, '¿Quién ganó el mundial de fútbol de 2010?', 'España', 'Argentina', 'Alemania'),
('Q710', 'D', 10, '¿Quién es el máximo goleador del FC Barcelona?', 'LIONEL MESSI', 'CÉSAR RODRÍGUEZ', 'LUIS SUÁREZ'),
('Q711', 'D', 11, '¿En qué club italiano jugó Diego Maradona?', 'Nápoli', 'Juventus', 'AC Milan'),
('Q712', 'D', 12, '¿Cuál de estos colores no forma parte de los colores de la camiseta del Atlético de Madrid?', 'Verde', 'rojo', 'blanco'),
('Q713', 'D', 13, '¿Qué equipo de la Premier League tiene más ligas ganadas?', 'Manchester United', 'River Plate', 'FC Barcelona'),
('Q714', 'D', 14, '¿Qué revista entrega el Balón de Oro?', 'France Football', 'Gazzetta dello Sport', 'Le Monde'),
('Q715', 'D', 15, '¿Qué selección ganó la Copa Mundial de Fútbol en Francia 1998?', 'Francia', 'Brasil', 'Argentina'),
('Q8', 'M', 8, '¿Cuántos metros es un hectómetro?', '100 metros', '10 metros', '5 metros'),
('Q801', 'E', 1, '¿Quién escribió la obra literaria Rayuela?', 'Julio Cortázar', 'Jorge Luis Borges', 'Gabriel García Márquez'),
('Q802', 'E', 2, '¿Qué raza canina protagoniza la serie de películas Beethoven?', 'San Bernardo', 'Poodle', 'Bulldog'),
('Q803', 'E', 3, '¿De cuál de estas famosas bandas es vocalista Mick Jagger?', 'The Rolling Stones', 'Pink Floyd', 'The Beatles'),
('Q804', 'E', 4, '¿En qué país originó el tango?', 'Argentina', 'Chile', 'México'),
('Q805', 'E', 5, '¿De dónde es la banda ABBA?', 'Suecia', 'Suiza', 'Italia'),
('Q806', 'E', 6, '¿Quién canta Livin’ la vida loca?', 'Ricky Martin', 'Chayanne', 'Residente'),
('Q807', 'E', 7, '¿De qué famoso rapero y cantante puertorriqueño es el álbum de estudio “Un verano sin ti” lanzado en 2022?', 'Bad Bunny', 'Residente', 'Daddy Yankee'),
('Q808', 'E', 8, '¿Quién de estas famosas artistas femeninas canta Genio Atrapado, Lady Marmalade, Candyman y Pa Mis Muchachas?', 'Christina Aguilera', 'Lady Gaga', 'Britney Spears'),
('Q809', 'E', 9, '¿Quién interpreta la canción De música ligera?', 'Soda Stereo', 'Enanitos Verdes', 'La Renga'),
('Q810', 'E', 10, '¿en qué país surge el tipo de música “El Merengue”?', 'República Dominicana', 'Puerto Rico', 'Cuba'),
('Q811', 'E', 11, '¿Cuál de estas canciones es interpretada por la cantante estadounidense Britney Spears?', 'todas las anteriores', '...Baby One More Time', 'Oops!... I Did It Again'),
('Q812', 'E', 12, '¿Qué país consume la infusión con hojas de yerba llamado mate?', 'todas las anteriores', 'Argentina', 'Brasil'),
('Q813', 'E', 13, '¿Quién dirigió la trilogía original de la saga Star Wars?', 'George Lucas', 'Martin Scorsese', 'Quentin Tarantino'),
('Q814', 'E', 14, '¿De qué famosa cantante mexicana es el álbum de estudio “Amor a la mexicana”?', 'Thalía', 'Sofía Reyes', 'Paty Cantú'),
('Q815', 'E', 15, '¿Qué actor interpretó al mago Gandalf en la trilogía de El Señor de los anillos?', 'Ian Mckellen', 'Viggo Mortensen', 'Elijah Wood'),
('Q9', 'M', 9, '¿Cuántos minutos tiene una hora?', '60 minutos', '10 minutos', '100 minutos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sala`
--

CREATE TABLE `sala` (
  `ID` varchar(5) NOT NULL,
  `fechacreacion` datetime DEFAULT NULL,
  `IDJuego` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `sala`
--

INSERT INTO `sala` (`ID`, `fechacreacion`, `IDJuego`) VALUES
('00000', '2023-04-02 04:17:54', 1);

--
-- Disparadores `sala`
--
DELIMITER $$
CREATE TRIGGER `afterinsertsala` AFTER INSERT ON `sala` FOR EACH ROW BEGIN
	DECLARE registroid int;
    DECLARE listo BOOLEAN DEFAULT FALSE;
	DECLARE salasviejas CURSOR FOR SELECT IDJuego FROM sala WHERE TIMESTAMPDIFF(HOUR,fechacreacion,CURRENT_TIMESTAMP) >= 1 AND NOT(ID='00000');
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET listo = TRUE;
    
	OPEN salasviejas;
    
    simple_loop: LOOP
    FETCH salasviejas INTO registroid;
    IF listo THEN
    	LEAVE simple_loop;
    END IF;
    DELETE FROM juego WHERE ID = registroid;
    END LOOP;
    
    CLOSE salasviejas;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_sala` BEFORE INSERT ON `sala` FOR EACH ROW begin
	declare maximo int;
	declare minimo int;
	declare ID_asignado int;
	select max(ID) from juego into maximo;
	select min(ID) from juego into minimo;
	
    IF minimo IS NULL THEN
    	SET ID_asignado = 1;
	ELSEIF minimo != 1 AND minimo > 0 THEN
		SET ID_asignado = minimo - 1;
	ELSE
		SET ID_asignado = maximo + 1;
   	end if;
    insert into juego values(ID_asignado);
    CALL crear_Juego(ID_asignado);
    
    SET new.IDJuego=ID_asignado;
    end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sala_jugador`
--

CREATE TABLE `sala_jugador` (
  `idsala` varchar(5) NOT NULL,
  `idjugador` int(11) NOT NULL,
  `tiempoUnion` datetime DEFAULT NULL,
  `puntaje` int(11) DEFAULT NULL,
  `tiempo` time DEFAULT cast('00:00:00' as time),
  `preguntas_respondidas` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `juego`
--
ALTER TABLE `juego`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `ID` (`ID`);

--
-- Indices de la tabla `juego_contiene_preguntas`
--
ALTER TABLE `juego_contiene_preguntas`
  ADD KEY `idjuego` (`idjuego`),
  ADD KEY `idpregunta` (`idpregunta`);

--
-- Indices de la tabla `jugador`
--
ALTER TABLE `jugador`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `ID` (`ID`),
  ADD KEY `IPPublic` (`IPPublic`),
  ADD KEY `IPLAN` (`IPLAN`);

--
-- Indices de la tabla `pregunta`
--
ALTER TABLE `pregunta`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `ID` (`ID`);

--
-- Indices de la tabla `sala`
--
ALTER TABLE `sala`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `ID` (`ID`),
  ADD KEY `IDJuego` (`IDJuego`);

--
-- Indices de la tabla `sala_jugador`
--
ALTER TABLE `sala_jugador`
  ADD KEY `idsala` (`idsala`),
  ADD KEY `idjugador` (`idjugador`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `juego_contiene_preguntas`
--
ALTER TABLE `juego_contiene_preguntas`
  ADD CONSTRAINT `juego_contiene_preguntas_ibfk_1` FOREIGN KEY (`idjuego`) REFERENCES `juego` (`ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `juego_contiene_preguntas_ibfk_2` FOREIGN KEY (`idpregunta`) REFERENCES `pregunta` (`ID`);

--
-- Filtros para la tabla `sala`
--
ALTER TABLE `sala`
  ADD CONSTRAINT `sala_ibfk_1` FOREIGN KEY (`IDJuego`) REFERENCES `juego` (`ID`) ON DELETE CASCADE;

--
-- Filtros para la tabla `sala_jugador`
--
ALTER TABLE `sala_jugador`
  ADD CONSTRAINT `sala_jugador_ibfk_1` FOREIGN KEY (`idsala`) REFERENCES `sala` (`ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `sala_jugador_ibfk_2` FOREIGN KEY (`idjugador`) REFERENCES `jugador` (`ID`) ON DELETE CASCADE;

DELIMITER $$
--
-- Eventos
--
CREATE DEFINER=`root`@`localhost` EVENT `GenerateADiario` ON SCHEDULE EVERY 24 HOUR STARTS '2023-04-01 00:00:00' ON COMPLETION PRESERVE ENABLE DO CALL ADiario()$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
