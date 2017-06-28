-- phpMyAdmin SQL Dump
-- version 4.5.2
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 28-06-2017 a las 22:07:18
-- Versión del servidor: 10.1.13-MariaDB
-- Versión de PHP: 7.0.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `jscrum`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarEstadoProyecto` (IN `_id_proyecto` INT)  BEGIN
	IF ( SELECT EXISTS (SELECT * FROM proyecto WHERE id = _id_proyecto))THEN
		UPDATE proyecto SET estado = "Terminado" WHERE id = _id_proyecto;
        SELECT 1 AS respuesta;
    ELSE
		SELECT 0 AS respuesta;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `asignarEquipoE` (IN `_email` VARCHAR(75), IN `_cargo` VARCHAR(100), IN `_id_equipo` INT)  BEGIN
DECLARE _id_miembro INT;
	    IF ( SELECT NOT EXISTS (SELECT * FROM usuario WHERE email = _email))THEN
			SELECT 0 AS respuesta;
   		ELSE
        SET _id_miembro = (SELECT m.id FROM usuario u INNER JOIN miembro m ON u.id = m.id_usuario WHERE u.email = _email);
        IF ( SELECT NOT EXISTS (SELECT * FROM equipo_miembro WHERE id_equipo=_id_equipo AND id_miembro=_id_miembro))THEN
			INSERT INTO equipo_miembro(cargo, id_equipo, id_miembro) VALUES(_cargo, _id_equipo, _id_miembro);
			SELECT 1 AS respuesta;
        ELSE
			SELECT 2 AS respuesta;
		END IF;
    END IF; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `asignarRol` (IN `_id` INT, IN `_rol` VARCHAR(45))  BEGIN
IF ( SELECT EXISTS (SELECT * FROM usuario WHERE id= _id))THEN
	UPDATE usuario SET rol = _rol WHERE id = _id;
    SELECT 1 as respuesta;
ELSE
	SELECT 0 as respuesta;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `asignarTarea` (IN `_indice` VARCHAR(5), IN `_codigo` VARCHAR(10), IN `_descripcion` TEXT, IN `_tipo` VARCHAR(10), IN `_total_horas` INT, IN `_id_sprint` INT, IN `_id_miembro` INT)  BEGIN
	IF (SELECT NOT EXISTS(SELECT * FROM tarea WHERE codigo=_codigo AND id_sprint=_id_sprint))THEN
		INSERT INTO tarea(indice, codigo, descripcion, tipo, total_horas, id_sprint, id_miembro) VALUES(_indice, _codigo, _descripcion, _tipo, _total_horas, _id_sprint, _id_miembro);
		UPDATE sprint SET total_tareas = total_tareas + 1, total_horas_persona = total_horas_persona + _total_horas WHERE id=_id_sprint;
		SELECT 1 AS respuesta;
	ELSE
		SELECT 0 AS respuesta;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cambiarFoto` (IN `_email` VARCHAR(75))  BEGIN
	IF ( SELECT EXISTS (SELECT * FROM usuario WHERE email = _email))THEN
		UPDATE usuario SET foto = CONCAT('images/',_email) WHERE email=_email;
        SELECT 1;
    ELSE
		SELECT 0;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cantidadDias` (IN `_id_sprint` INT)  BEGIN
DECLARE tmp_fechas DATE;
DECLARE _fecha_entrega DATE;
	IF(SELECT EXISTS (SELECT * FROM sprint WHERE id=_id_sprint))THEN
		SET _fecha_entrega = (SELECT fecha_entrega FROM sprint WHERE id=_id_sprint);
		SET tmp_fechas = (SELECT fecha_inicio FROM sprint WHERE id=_id_sprint);
        CREATE TEMPORARY TABLE fechas(dia_habil DATE)engine=memory;
		WHILE tmp_fechas<=_fecha_entrega DO
			IF(SELECT NOT EXISTS (SELECT * FROM dias_inhabiles WHERE dia_inhabil=tmp_fechas))THEN
				insert into fechas select tmp_fechas;
			END IF;
            SET tmp_fechas = (DATE_ADD(tmp_fechas,INTERVAL 1 DAY));
		end while;
		select count(dia_habil) from fechas;
		drop temporary table if exists fechas;
	ELSE
		SELECT 0 AS respuesta;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `crearEquipo` (IN `_nombre` VARCHAR(45), IN `_jornada` VARCHAR(2), IN `_id_manager` INT)  BEGIN
	INSERT INTO equipo(nombre, jornada, id_manager) VALUES(_nombre, _jornada, _id_manager);
    SELECT 1 as respuesta;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `crearPila` (IN `_codigo` VARCHAR(10), IN `_historia` TEXT, IN `_importancia` VARCHAR(2), IN `_estimado_horas` INT, IN `_id_proyecto` INT)  BEGIN
	    IF ( SELECT EXISTS (SELECT * FROM pila WHERE codigo = _codigo AND id_proyecto = _id_proyecto))THEN 
			SELECT 0 as respuesta;
   		ELSE
			INSERT INTO pila(codigo, historia, importancia, estimado_horas, id_proyecto) VALUES(_codigo, _historia, _importancia, _estimado_horas, _id_proyecto);
            SELECT 1 as respuesta;
    END IF; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `crearProyecto` (IN `_codigo` VARCHAR(10), IN `_nombre` VARCHAR(100), IN `_descripcion` TEXT, IN `_objetivo` TEXT, IN `_id_manager` INT, IN `_id_equipo` INT)  BEGIN
	IF ( SELECT EXISTS (SELECT * FROM proyecto WHERE codigo = _codigo))THEN
		SELECT 0;
	ELSE
		INSERT INTO proyecto(codigo, nombre, descripcion, objetivo, id_manager, id_equipo) VALUES(_codigo, _nombre, _descripcion, _objetivo, _id_manager, _id_equipo);
		SELECT 1;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `crearSprint` (IN `_codigo` VARCHAR(10), IN `_fecha_entrega` DATE, IN `_id_proyecto` INT)  BEGIN
IF ( SELECT EXISTS (SELECT * FROM sprint WHERE codigo = _codigo))THEN
	SELECT 0;
ELSE
	INSERT INTO sprint(codigo, fecha_inicio, fecha_entrega, id_proyecto) VALUES(_codigo, CURDATE(), _fecha_entrega, _id_proyecto);
	SELECT 1;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `graficoHoras` (IN `_id_sprint` INT)  BEGIN
	IF (SELECT EXISTS (SELECT * FROM seguimiento WHERE id_sprint=_id_sprint))THEN
		SELECT sp.total_horas, sp.total_tareas, se.tareas_persona_pendientes, se.horas_persona_pendientes, se.fecha_seguimiento
        FROM seguimiento se INNER JOIN sprint sp ON sp.id=se.id_sprint WHERE sp.id=_id_sprint;
    ELSE
    SELECT 0;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `idManager` (IN `_id_usuario` INT)  BEGIN
	    IF ( SELECT EXISTS (SELECT * FROM usuario WHERE id=_id_usuario))THEN
			IF ( SELECT EXISTS (SELECT * FROM manager WHERE id_usuario = _id_usuario))THEN 
				SELECT m.id FROM usuario u INNER JOIN manager m ON u.id=m.id_usuario WHERE m.id_usuario=_id_usuario;
			ELSE
				SELECT 2 as respuesta;
			END IF;
		ELSE
			SELECT 0 as respuesta;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `idMiembro` (IN `_id_usuario` INT)  BEGIN
	    IF ( SELECT EXISTS (SELECT * FROM usuario WHERE id=_id_usuario))THEN
			IF ( SELECT EXISTS (SELECT * FROM miembro WHERE id_usuario = _id_usuario))THEN 
				SELECT m.id FROM usuario u INNER JOIN miembro m ON u.id=m.id_usuario WHERE m.id_usuario=_id_usuario;
			ELSE
				SELECT 2 as respuesta;
			END IF;
		ELSE
			SELECT 0 as respuesta;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertarDiaInhabil` (IN `_dia_inhabil` DATE, IN `_id_sprint` INT)  BEGIN
IF ( SELECT EXISTS (SELECT * FROM dias_inhabiles WHERE dia_inhabil = _dia_inhabil AND id_sprint = _id_sprint))THEN
	SELECT 0;
ELSE
	INSERT INTO dias_inhabiles(dia_inhabil, id_sprint) VALUES(_dia_inhabil, _id_sprint);
	SELECT 1;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertarManager` (IN `_experiencia` VARCHAR(100), IN `_id_usuario` INT)  BEGIN
	    IF ( SELECT EXISTS (SELECT * FROM usuario WHERE id = _id_usuario))THEN 
			IF ( SELECT NOT EXISTS (SELECT * FROM manager WHERE id_usuario = _id_usuario))THEN 
				INSERT INTO manager(experiencia, id_usuario) VALUES (_experiencia, _id_usuario);
                SELECT 1 as respuesta;
			ELSE
				SELECT 2 as respuesta;
            END IF;
   		ELSE
			SELECT 0 as respuesta;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertarMiembro` (IN `_destrezas` VARCHAR(100), IN `_id_usuario` INT)  BEGIN
	    IF ( SELECT EXISTS (SELECT * FROM usuario WHERE id = _id_usuario))THEN 
			IF ( SELECT NOT EXISTS (SELECT * FROM miembro WHERE id_usuario = _id_usuario))THEN 
				INSERT INTO miembro(destrezas, id_usuario) VALUES (_destrezas, _id_usuario);
                SELECT 1 as respuesta;
			ELSE
				SELECT 2 as respuesta;
            END IF;
   		ELSE
			SELECT 0 as respuesta;
    END IF; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertarProyectoSprint` (IN `_indice` VARCHAR(3), IN `_codigo` VARCHAR(10), IN `_historia` TEXT, IN `_importancia` VARCHAR(2), IN `_estimado_horas` INT, IN `_id_sprint` INT, IN `_id_proyecto` INT)  BEGIN
	    IF ( SELECT EXISTS (SELECT * FROM proyecto_sprint WHERE codigo = _codigo))THEN 
			SELECT 0 AS respuesta;
   		ELSE
			INSERT INTO proyecto_sprint(indice ,codigo, historia, importancia, estimado_horas, id_sprint, id_proyecto) VALUES(_indice, _codigo, _historia, _importancia, _estimado_horas, _id_sprint, _id_proyecto);
            UPDATE sprint SET total_horas = total_horas + _estimado_horas WHERE id = _id_sprint;
            SELECT 1 AS respuesta;
    END IF; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertarUsuario` (IN `_nombre` VARCHAR(45), IN `_apellidos` VARCHAR(75), IN `_email` VARCHAR(75), IN `_login` VARCHAR(55), IN `_password` VARCHAR(35), IN `_profesion` VARCHAR(40))  BEGIN
DECLARE _retorno VARCHAR(40);
	    IF ( SELECT EXISTS (SELECT * FROM usuario WHERE login = _login))THEN 
            SELECT 2 as respuesta;
   		ELSE
        	IF ( SELECT EXISTS (SELECT * FROM usuario WHERE email = _email))THEN 
				SELECT 0 as respuesta;
   			ELSE
				INSERT INTO usuario(nombre, apellidos, email, login, password, profesion) VALUES(_nombre, _apellidos, _email, _login, _password, _profesion);
                SELECT 1 as respuesta;
            END IF;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listarDias` (IN `_id_sprint` INT)  BEGIN
DECLARE tmp_fechas DATE;
DECLARE _fecha_entrega DATE;
	IF(SELECT EXISTS (SELECT * FROM sprint WHERE id=_id_sprint))THEN
		SET _fecha_entrega = (SELECT fecha_entrega FROM sprint WHERE id=_id_sprint);
		SET tmp_fechas = (SELECT fecha_inicio FROM sprint WHERE id=_id_sprint);
        CREATE TEMPORARY TABLE fechas(dia_habil DATE)engine=memory;
		WHILE tmp_fechas<=_fecha_entrega DO
			IF(SELECT NOT EXISTS (SELECT * FROM dias_inhabiles WHERE dia_inhabil=tmp_fechas))THEN
				insert into fechas select tmp_fechas;
			END IF;
            SET tmp_fechas = (DATE_ADD(tmp_fechas,INTERVAL 1 DAY));
		end while;
		select dia_habil from fechas;
		drop temporary table if exists fechas;
	ELSE
		SELECT 0 AS respuesta;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listarEquipos` (IN `_id_manager` INT)  BEGIN
	    IF ( SELECT EXISTS (SELECT * FROM equipo WHERE id_manager = _id_manager))THEN 
			SELECT * FROM equipo WHERE id_manager = _id_manager;
   		ELSE
			SELECT 0 as respuesta;
		END IF; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listarEquiposMi` (IN `_id_miembro` INT)  BEGIN
	    IF ( SELECT EXISTS (SELECT * FROM equipo_miembro WHERE id_miembro = _id_miembro))THEN
			SELECT  e.id, e.nombre, e.jornada, em.id AS id_equipo, em.cargo FROM equipo e INNER JOIN equipo_miembro em ON e.id=em.id_equipo WHERE em.id_miembro = _id_miembro;
   		ELSE
			SELECT 0 as respuesta;
		END IF; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listarEquiposProyectos` (IN `_id_manager` INT)  BEGIN
 IF ( SELECT EXISTS (SELECT * FROM equipo WHERE id_manager = _id_manager))THEN 
			IF ( SELECT EXISTS (SELECT * FROM proyecto WHERE id_equipo = _id_manager))THEN 
				SELECT * FROM equipo e INNER JOIN proyecto p ON e.id=p.id_equipo WHERE e.id_manager = _id_manager;
			ELSE
				SELECT 2 as respuesta;
			END IF; 
   		ELSE
            SELECT 0 as respuesta;
    END IF; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listarEsfuerzo` (IN `_id_sprint` INT)  BEGIN
DECLARE _id_tarea INT;
	IF (SELECT EXISTS (SELECT * FROM tarea WHERE id_sprint=_id_sprint))THEN
		IF (SELECT EXISTS (SELECT * FROM tarea t INNER JOIN esfuerzo e ON t.id=e.id_tarea WHERE id_sprint=_id_sprint))THEN
			SELECT  table1.id, table1.indice, table1.codigo, table1.descripcion, table1.tipo, table1.estado, table1.total_horas, table1.id_miembro,  table1.id, table1.cantidad, table1.fecha_dia, table1.id_tarea, group_concat(table1.cantidad separator ',') cantidades 
			FROM (SELECT t.id, t.indice, t.codigo, t.descripcion, t.tipo, t.estado, t.total_horas, t.id_miembro, e.id_tarea, e.cantidad, e.fecha_dia FROM tarea t INNER JOIN esfuerzo e ON t.id=e.id_tarea WHERE t.id_sprint=_id_sprint
			ORDER BY e.cantidad) table1 GROUP BY table1.id_tarea;
		ELSE
			SELECT * FROM tarea WHERE id_sprint=_id_sprint;
        END IF;
	ELSE
		SELECT 0 AS respuesta;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listarInhabiles` (IN `_id_sprint` INT)  BEGIN
	IF (SELECT EXISTS (SELECT * FROM dias_inhabiles WHERE id_sprint=_id_sprint))THEN
		SELECT * FROM dias_inhabiles WHERE id_sprint=_id_sprint;
    ELSE
		SELECT 0 AS respuesta;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listarMiembrosE` (IN `_id_proyecto` INT)  BEGIN
DECLARE _id_equipo INT;
	IF ( SELECT EXISTS (SELECT * FROM proyecto WHERE id = _id_proyecto))THEN
		SET _id_equipo = (SELECT id_equipo FROM proyecto WHERE id=_id_proyecto);
        SELECT m.id, u.nombre, u.apellidos, e.cargo FROM equipo_miembro e INNER JOIN miembro m ON e.id_miembro=m.id INNER JOIN usuario u ON m.id_usuario=u.id WHERE e.id_equipo=_id_equipo;
	ELSE
		SELECT 0 as respuesta;
	END IF; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listarMiembrosEquipo` (IN `_id_equipo` INT)  BEGIN
	IF ( SELECT EXISTS (SELECT * FROM equipo_miembro WHERE id_equipo = _id_equipo))THEN
        SELECT m.id, u.nombre, u.apellidos, e.cargo, m.destrezas FROM equipo_miembro e INNER JOIN miembro m ON e.id_miembro=m.id INNER JOIN usuario u ON m.id_usuario=u.id WHERE e.id_equipo=_id_equipo;
	ELSE
		SELECT 0 as respuesta;
	END IF; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listarMiembrosEquipos` (IN `_id_manager` INT)  BEGIN
	IF ( SELECT EXISTS (SELECT * FROM equipo WHERE id_manager = _id_manager))THEN
        SELECT e.id, m.id, u.nombre, u.apellidos, em.cargo FROM equipo e INNER JOIN equipo_miembro em ON e.id=em.id_equipo INNER JOIN miembro m ON em.id_miembro=m.id INNER JOIN usuario u ON m.id_usuario=u.id 
        WHERE e.id_manager=_id_manager ORDER BY e.id;
	ELSE
		SELECT 0 as respuesta;
	END IF; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listarPila` (IN `_id_proyecto` INT)  BEGIN
	IF ( SELECT EXISTS (SELECT * FROM pila WHERE id_proyecto = _id_proyecto))THEN 
		SELECT * FROM pila WHERE id_proyecto = _id_proyecto
		ORDER BY importancia DESC;
	ELSE
            SELECT 0 as respuesta;
    END IF; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listarProyectos` (IN `_id_equipo` INT)  BEGIN
	    IF ( SELECT EXISTS (SELECT * FROM equipo WHERE id = _id_equipo))THEN 
			IF ( SELECT EXISTS (SELECT * FROM proyecto WHERE id_equipo = _id_equipo))THEN 
				SELECT * FROM proyecto WHERE id_equipo = _id_equipo
                ORDER BY fecha DESC;
			ELSE
				SELECT 2 as respuesta;
			END IF; 
   		ELSE
            SELECT 0 as respuesta;
    END IF; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listarProyectoSprint` (IN `_id_sprint` INT, IN `_id_proyecto` INT)  BEGIN
	    IF ( SELECT EXISTS (SELECT * FROM proyecto_sprint WHERE id_sprint = _id_sprint AND id_proyecto = _id_proyecto))THEN
			SELECT * FROM proyecto_sprint WHERE id_sprint = _id_sprint AND id_proyecto = _id_proyecto
            ORDER BY CAST(indice AS UNSIGNED);
   		ELSE
			SELECT 0 as respuesta;
		END IF; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listarSeguimiento` (IN `_id_sprint` INT)  BEGIN
	IF (SELECT EXISTS (SELECT * FROM seguimiento WHERE id_sprint=_id_sprint))THEN
		SELECT * FROM seguimiento WHERE id_sprint = _id_sprint;
    ELSE
		SELECT 0;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listarSprint` (IN `_id_proyecto` INT)  BEGIN
	    IF ( SELECT EXISTS (SELECT * FROM sprint WHERE id_proyecto = _id_proyecto))THEN
			SELECT * FROM sprint WHERE id_proyecto=_id_proyecto;
   		ELSE
			SELECT 0 as respuesta;
		END IF; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listarTareas` (IN `_id_sprint` INT)  BEGIN
	IF(SELECT EXISTS (SELECT * FROM tarea WHERE id_sprint=_id_sprint))THEN
		SELECT * FROM tarea WHERE id_sprint=_id_sprint ORDER by indice;
    ELSE
		SELECT 0 AS respuesta;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `login` (IN `_login` VARCHAR(55), IN `_password` VARCHAR(35))  BEGIN
	    IF ( SELECT EXISTS (SELECT * FROM usuario WHERE login = _login AND password = _password))THEN 
			SELECT id, nombre, apellidos, email, login, rol, foto FROM usuario WHERE login = _login;
   		ELSE
			SELECT 0 as response;
    END IF; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `modificarEstado` (IN `_estado` VARCHAR(15), IN `_id_tarea` INT)  BEGIN
	IF(SELECT EXISTS (SELECT * FROM tarea WHERE id=_id_tarea) )THEN
		UPDATE tarea SET estado=_estado WHERE id=_id_tarea;
        SELECT 1 AS respuesta;
    ELSE
		SELECT 0 AS respuesta;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `quemarHoras` (IN `_cantidad` INT, IN `_id_tarea` INT, IN `_id_sprint` INT)  BEGIN
DECLARE _tareas_pendientes INT DEFAULT 0; 
DECLARE _horas_pendientes INT DEFAULT 0;
DECLARE _horas_completas INT DEFAULT 0;
DECLARE _id_esfuerzo INT;
	IF ( SELECT EXISTS (SELECT * FROM esfuerzo WHERE fecha_dia = CURDATE() AND id_tarea=_id_tarea))THEN 
        SELECT 0 as respuesta;
   		ELSE
        IF ( SELECT EXISTS (SELECT * FROM esfuerzo WHERE cantidad <= _cantidad  AND fecha_dia=(CURDATE()-1) ))THEN
			INSERT INTO esfuerzo(cantidad, fecha_dia, id_tarea) VALUES(_cantidad, CURDATE(),_id_tarea);
			SET _id_esfuerzo = (@@identity);
            IF (_cantidad = 0)THEN
				SET _tareas_pendientes = (SELECT (total_tareas - 1) FROM sprint WHERE id=_id_sprint);
                UPDATE tarea SET estado="Terminado" WHERE id=_id_tarea;
			ELSE
				SET _tareas_pendientes = (SELECT (total_tareas) FROM sprint WHERE id=_id_sprint);
			END IF;           
            SET _horas_completas = (SELECT (t.total_horas - e.cantidad) FROM tarea t INNER JOIN esfuerzo e ON t.id = e.id_tarea WHERE e.id = _id_esfuerzo);   
            SET _horas_pendientes = (SELECT (total_horas_persona - _horas_completas) FROM sprint WHERE id=_id_sprint);   
			INSERT INTO seguimiento(tareas_persona_pendientes, 	horas_persona_pendientes, fecha_seguimiento, id_sprint) VALUES(_tareas_pendientes, _horas_pendientes, CURDATE(), _id_sprint);
            SELECT 1 as respuesta;
		ELSE
        SELECT 2 AS respuesta;
        END IF;
    END IF; 
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dias_inhabiles`
--

CREATE TABLE `dias_inhabiles` (
  `id` int(11) NOT NULL,
  `dia_inhabil` date NOT NULL,
  `id_sprint` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `equipo`
--

CREATE TABLE `equipo` (
  `id` int(11) NOT NULL,
  `nombre` varchar(45) COLLATE utf8_spanish2_ci NOT NULL,
  `jornada` varchar(2) COLLATE utf8_spanish2_ci NOT NULL DEFAULT '8',
  `id_manager` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `equipo`
--

INSERT INTO `equipo` (`id`, `nombre`, `jornada`, `id_manager`) VALUES
(12, 'RootCode', '8', 11),
(13, 'JavascriptPro', '8', 11);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `equipo_miembro`
--

CREATE TABLE `equipo_miembro` (
  `id` int(11) NOT NULL,
  `cargo` varchar(100) COLLATE utf8_spanish2_ci NOT NULL,
  `id_equipo` int(11) NOT NULL,
  `id_miembro` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `equipo_miembro`
--

INSERT INTO `equipo_miembro` (`id`, `cargo`, `id_equipo`, `id_miembro`) VALUES
(18, 'Responsable de diseño', 13, 15),
(22, 'Sin Cargo', 12, 15),
(25, 'Developer', 12, 18),
(26, 'Responsable de base de datos', 12, 19);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `esfuerzo`
--

CREATE TABLE `esfuerzo` (
  `id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT '0',
  `fecha_dia` date NOT NULL,
  `id_tarea` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `esfuerzo`
--

INSERT INTO `esfuerzo` (`id`, `cantidad`, `fecha_dia`, `id_tarea`) VALUES
(47, 2, '2017-06-28', 12),
(50, 1, '0000-00-00', 12),
(51, 2, '0000-00-00', 13),
(52, 2, '0000-00-00', 13);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manager`
--

CREATE TABLE `manager` (
  `id` int(11) NOT NULL,
  `experiencia` varchar(3) COLLATE utf8_spanish2_ci NOT NULL,
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `manager`
--

INSERT INTO `manager` (`id`, `experiencia`, `id_usuario`) VALUES
(11, '2', 61),
(12, '3', 57),
(13, '4', 63);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `miembro`
--

CREATE TABLE `miembro` (
  `id` int(11) NOT NULL,
  `destrezas` varchar(100) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `estado` varchar(15) COLLATE utf8_spanish2_ci NOT NULL DEFAULT 'A',
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `miembro`
--

INSERT INTO `miembro` (`id`, `destrezas`, `estado`, `id_usuario`) VALUES
(15, 'Front-end, Interfaces con AngularJS', 'A', 62),
(16, 'Diseñadora de base de datos no relacionales, Backend', 'A', 60),
(17, 'Analista de Sistemas', 'A', 59),
(18, 'Testing', 'A', 58),
(19, 'Especialista en Diseño de interfaces responsivas', 'A', 65),
(20, 'Desarrollo de aplicaciones Web y android', 'A', 64);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pila`
--

CREATE TABLE `pila` (
  `id` int(11) NOT NULL,
  `codigo` varchar(10) COLLATE utf8_spanish2_ci NOT NULL,
  `historia` text COLLATE utf8_spanish2_ci NOT NULL,
  `importancia` varchar(3) COLLATE utf8_spanish2_ci NOT NULL,
  `estimado_horas` int(3) NOT NULL,
  `id_proyecto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `pila`
--

INSERT INTO `pila` (`id`, `codigo`, `historia`, `importancia`, `estimado_horas`, `id_proyecto`) VALUES
(17, 'B001', 'El docente deberá poder realizar observaciones en un documento word y estas deben poder almacenarce en base de datos', '5', 24, 25),
(18, 'B002', 'El docente deberá poder visualizar el documento word', '5', 16, 25),
(19, 'B003', 'El alumno deberá poder recuperar el documento word con las observaciones realizadas por el docente', '4', 8, 25),
(20, 'B004', 'Tanto docente como alumno deberán poder registrarse en el sistema para poder acceder', '2', 4, 25),
(21, 'B005', 'El docente podrá modificar o eliminar observaciones del documento', '4', 16, 25),
(22, 'B006', 'Realizar reportes de todas las observaciones realizadas en el documento', '4', 16, 25),
(23, 'B007', 'Traspaso de documento entre docentes', '3', 10, 25),
(24, 'H100', 'El sistema deberá tener una interfaz donde se insertarán todos los productos de la farmacia', '5', 48, 26),
(25, 'H200', 'El sistema deberá tener una funcionalidad de búsqueda de artículos', '4', 24, 26),
(26, 'H250', 'El sistema deberá registrar a los administradores del sistema y los usuarios', '2', 16, 26),
(27, 'H150', 'El sistema deberá registrar las compras realizadas', '5', 36, 26),
(28, 'H255', 'El sistema deberá registrar reportes diarios, semanales y mensuales de las ventas realizadas', '3', 36, 26);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyecto`
--

CREATE TABLE `proyecto` (
  `id` int(11) NOT NULL,
  `codigo` varchar(10) COLLATE utf8_spanish2_ci NOT NULL,
  `nombre` varchar(100) COLLATE utf8_spanish2_ci NOT NULL,
  `descripcion` text COLLATE utf8_spanish2_ci NOT NULL,
  `objetivo` text COLLATE utf8_spanish2_ci NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` varchar(15) COLLATE utf8_spanish2_ci NOT NULL DEFAULT 'En proceso',
  `id_manager` int(11) NOT NULL,
  `id_equipo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `proyecto`
--

INSERT INTO `proyecto` (`id`, `codigo`, `nombre`, `descripcion`, `objetivo`, `fecha`, `estado`, `id_manager`, `id_equipo`) VALUES
(25, 'P001', 'Gitgrad', 'Aplicación de escritorio para versionar documentos digitales', 'Desarrollar una aplicación que permita crear versiones de un documento word para una revisión contínua', '2017-06-28 04:08:07', 'En proceso', 11, 12),
(26, 'P250', 'FarmaHost', 'Aplicación Web para la gestión de una farmacia', 'Gestionar de manera eficiente las actividades realizadas y los artículos existentes en una farmacia', '2017-06-28 05:20:44', 'En proceso', 11, 12);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyecto_sprint`
--

CREATE TABLE `proyecto_sprint` (
  `id` int(11) NOT NULL,
  `indice` varchar(5) COLLATE utf8_spanish2_ci NOT NULL DEFAULT '0',
  `codigo` varchar(10) COLLATE utf8_spanish2_ci NOT NULL,
  `historia` text COLLATE utf8_spanish2_ci NOT NULL,
  `importancia` varchar(2) COLLATE utf8_spanish2_ci NOT NULL,
  `estimado_horas` int(11) NOT NULL,
  `id_sprint` int(11) NOT NULL,
  `id_proyecto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `proyecto_sprint`
--

INSERT INTO `proyecto_sprint` (`id`, `indice`, `codigo`, `historia`, `importancia`, `estimado_horas`, `id_sprint`, `id_proyecto`) VALUES
(44, '1.1', 'S004', 'El docente deberá registrar observaciones embebidas al documento Word del estudiante', '5', 16, 12, 25),
(45, '1.2', 'S005', 'El docente deberá registrar observaciones y guardarlas en la base de datos', '5', 8, 12, 25),
(46, '3', 'C400', 'El alumno deberá recuperar las observaciones en su documento Word para poder revisarlo', '4', 8, 13, 25),
(47, '4', 'C401', 'El docente deberá modificar o eliminar observaciones en un documento', '4', 16, 13, 25),
(48, '5', 'D444', 'El sistema deberá realizar reportes de las observaciones realizadas en el documento de un alumno registrado', '4', 16, 14, 25),
(49, '6', 'D440', 'Un docente podrá pasar un documento que debía revisar a otro docente para finalizar su revisión', '3', 10, 14, 25),
(50, '7', 'D455', 'Tanto docentes como estudiantes deberán registrarse en el sistema y previamente acceder a él medinte un login', '2', 4, 14, 25);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seguimiento`
--

CREATE TABLE `seguimiento` (
  `id` int(11) NOT NULL,
  `tareas_persona_pendientes` int(11) NOT NULL,
  `horas_persona_pendientes` int(11) NOT NULL,
  `fecha_seguimiento` date NOT NULL,
  `id_sprint` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sprint`
--

CREATE TABLE `sprint` (
  `id` int(11) NOT NULL,
  `codigo` varchar(10) COLLATE utf8_spanish2_ci NOT NULL,
  `total_horas` int(3) DEFAULT '0',
  `fecha_inicio` date NOT NULL,
  `fecha_entrega` date NOT NULL,
  `total_tareas` int(2) DEFAULT '0',
  `total_horas_persona` int(11) NOT NULL DEFAULT '0',
  `estado` varchar(15) COLLATE utf8_spanish2_ci DEFAULT 'En proceso',
  `id_proyecto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `sprint`
--

INSERT INTO `sprint` (`id`, `codigo`, `total_horas`, `fecha_inicio`, `fecha_entrega`, `total_tareas`, `total_horas_persona`, `estado`, `id_proyecto`) VALUES
(12, 'SP20', 24, '2017-06-21', '2017-06-28', 1, 8, 'En proceso', 25),
(13, 'SP25', 24, '2017-06-29', '2017-07-09', 1, 12, 'En proceso', 25),
(14, 'SP30', 30, '2017-07-10', '2017-07-16', 0, 0, 'En proceso', 25),
(15, 'S35', 0, '2017-06-28', '2017-06-30', 0, 0, 'En proceso', 25);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tarea`
--

CREATE TABLE `tarea` (
  `id` int(11) NOT NULL,
  `indice` varchar(5) COLLATE utf8_spanish2_ci NOT NULL,
  `codigo` varchar(10) COLLATE utf8_spanish2_ci NOT NULL,
  `descripcion` text COLLATE utf8_spanish2_ci NOT NULL,
  `tipo` varchar(10) COLLATE utf8_spanish2_ci NOT NULL DEFAULT 'Principal',
  `estado` varchar(11) COLLATE utf8_spanish2_ci NOT NULL DEFAULT 'En proceso',
  `total_horas` int(2) NOT NULL,
  `id_sprint` int(11) NOT NULL,
  `id_miembro` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `tarea`
--

INSERT INTO `tarea` (`id`, `indice`, `codigo`, `descripcion`, `tipo`, `estado`, `total_horas`, `id_sprint`, `id_miembro`) VALUES
(12, '1.1', 'T400', 'desarrollo de funcionalidad para el registro de observaciones en un documento Word', 'Principal', 'En proceso', 8, 12, 15),
(13, '1.2', 'F002', 'Desarrollo de la funcionalidad', 'Principal', 'En proceso', 8, 12, 15),
(15, '3', 'S001', 'Visualizacion de datos', 'Principal', 'En proceso', 12, 13, 18);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id` int(11) NOT NULL,
  `nombre` varchar(45) COLLATE utf8_spanish2_ci NOT NULL,
  `apellidos` varchar(75) COLLATE utf8_spanish2_ci NOT NULL,
  `email` varchar(75) COLLATE utf8_spanish2_ci NOT NULL,
  `login` varchar(55) COLLATE utf8_spanish2_ci NOT NULL,
  `password` varchar(35) COLLATE utf8_spanish2_ci NOT NULL,
  `profesion` varchar(40) COLLATE utf8_spanish2_ci NOT NULL,
  `rol` varchar(45) COLLATE utf8_spanish2_ci NOT NULL DEFAULT 'Usuario',
  `foto` varchar(400) COLLATE utf8_spanish2_ci NOT NULL DEFAULT 'user.svg'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id`, `nombre`, `apellidos`, `email`, `login`, `password`, `profesion`, `rol`, `foto`) VALUES
(55, 'Erwin', 'Méndez', 'erwinXYZ1@gmail.com', 'admin', '1234', 'Ingeniero de Sistemas', 'Administrador', 'user.svg'),
(57, 'Amancaya Noelia', 'Iriarte Negrón', 'kaya@gmail.com', 'Amancaya', '1234', 'Ingeniera de Sistemas', 'Manager', 'user.svg'),
(58, 'Fabian', 'Janko Escalante', 'fabian@gmail.com', 'fabian', '1234', 'Ingeniero de Sistemas', 'Usuario', 'user.svg'),
(59, 'Yanin', 'Oquendo Tejerina', 'yanin@gmail.com', 'yanin', '1234', 'Administrador de Empresas', 'Usuario', 'user.svg'),
(60, 'Jacqueline', 'Méndez Mejía', 'jacqueline@gmail.com', 'jacqueline', '1234', 'Ingeniera de Sistemas', 'Usuario', 'user.svg'),
(61, 'Gary David', 'Guzman', 'gary@gmail.com', 'gary', '1234', 'Ingeniero de Sistemas', 'Manager', 'user.svg'),
(62, 'Analy', 'Polares Daza', 'analy@gmail.com', 'analy', '1234', 'Ingeniera de Sistemas', 'Usuario', 'user.svg'),
(63, 'Benjamin', 'Castillo Egues', 'benjamin@gmail.com', 'benjamin', '1234', 'Ingeniero de Sistemas', 'Manager', 'user.svg'),
(64, 'Juan Pablo', 'Siles Gutierrez', 'juanpa@gmail.com', 'juan', '1234567', 'Ingeniero de Sistemas', 'Usuario', 'user.svg'),
(65, 'Israel', 'Gonzales', 'israel@gmail.com', 'israel', '1234567', 'Ingeniero de Sistemas', 'Usuario', 'user.svg');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `dias_inhabiles`
--
ALTER TABLE `dias_inhabiles`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `equipo`
--
ALTER TABLE `equipo`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `equipo_miembro`
--
ALTER TABLE `equipo_miembro`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `esfuerzo`
--
ALTER TABLE `esfuerzo`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `manager`
--
ALTER TABLE `manager`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `miembro`
--
ALTER TABLE `miembro`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `pila`
--
ALTER TABLE `pila`
  ADD PRIMARY KEY (`id`),
  ADD KEY `indiceBacklog` (`codigo`);

--
-- Indices de la tabla `proyecto`
--
ALTER TABLE `proyecto`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `proyecto_sprint`
--
ALTER TABLE `proyecto_sprint`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `seguimiento`
--
ALTER TABLE `seguimiento`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `sprint`
--
ALTER TABLE `sprint`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tarea`
--
ALTER TABLE `tarea`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `dias_inhabiles`
--
ALTER TABLE `dias_inhabiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT de la tabla `equipo`
--
ALTER TABLE `equipo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
--
-- AUTO_INCREMENT de la tabla `equipo_miembro`
--
ALTER TABLE `equipo_miembro`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;
--
-- AUTO_INCREMENT de la tabla `esfuerzo`
--
ALTER TABLE `esfuerzo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;
--
-- AUTO_INCREMENT de la tabla `manager`
--
ALTER TABLE `manager`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT de la tabla `miembro`
--
ALTER TABLE `miembro`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
--
-- AUTO_INCREMENT de la tabla `pila`
--
ALTER TABLE `pila`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;
--
-- AUTO_INCREMENT de la tabla `proyecto`
--
ALTER TABLE `proyecto`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;
--
-- AUTO_INCREMENT de la tabla `proyecto_sprint`
--
ALTER TABLE `proyecto_sprint`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;
--
-- AUTO_INCREMENT de la tabla `seguimiento`
--
ALTER TABLE `seguimiento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT de la tabla `sprint`
--
ALTER TABLE `sprint`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT de la tabla `tarea`
--
ALTER TABLE `tarea`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
