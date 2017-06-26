-- phpMyAdmin SQL Dump
-- version 4.5.2
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 26-06-2017 a las 16:37:52
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `asginarEquipoE` (IN `_email` VARCHAR(75), IN `_cargo` VARCHAR(100), IN `_id_equipo` INT)  BEGIN
DECLARE _id_miembro INT;
	    IF ( SELECT NOT EXISTS (SELECT * FROM usuario WHERE email = _email))THEN
			SELECT 0 AS respuesta;
   		ELSE
        	SET _id_miembro = (SELECT m.id FROM usuario u INNER JOIN miembro m ON u.id = m.id_usuario WHERE u.email = _email);
			INSERT INTO equipo_miembro(cargo, id_equipo, id_miembro) VALUES(_cargo, _id_equipo, _id_miembro);
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
		select * from fechas;
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
			SELECT * FROM equipo e INNER JOIN equipo_miembro em ON e.id=em.id_equipo WHERE em.id_miembro = _id_miembro;
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
	IF EXISTS(SELECT EXISTS (SELECT * FROM tarea WHERE id_sprint=_id_sprint))THEN
		SELECT table1.id_tarea, group_concat(table1.cantidad separator ',') cantidades FROM (SELECT e.id_tarea, e.cantidad FROM tarea t INNER JOIN esfuerzo e ON t.id=e.id_tarea WHERE t.id_sprint=_id_sprint
        ORDER BY e.id_tarea ASC) table1 GROUP BY id_tarea;
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
        SELECT * FROM equipo_miembro e INNER JOIN miembro m ON e.id_miembro=m.id INNER JOIN usuario u ON m.id_usuario=u.id WHERE e.id_equipo=_id_equipo;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `listarSprint` (IN `_id_proyecto` INT)  BEGIN
	    IF ( SELECT EXISTS (SELECT * FROM sprint WHERE id_proyecto = _id_proyecto))THEN
			SELECT * FROM sprint WHERE id_proyecto=_id_proyecto;
   		ELSE
			SELECT 0 as respuesta;
		END IF; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listarTareas` (IN `_id_sprint` INT)  BEGIN
	IF(SELECT EXISTS (SELECT * FROM tarea WHERE id_sprint=_id_sprint))THEN
		SELECT * FROM tarea WHERE id_sprint=_id_sprint;
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

--
-- Volcado de datos para la tabla `dias_inhabiles`
--

INSERT INTO `dias_inhabiles` (`id`, `dia_inhabil`, `id_sprint`) VALUES
(5, '2017-06-23', 2);

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
(6, 'RootCode', '8', 7),
(7, 'Devian', '8', 7),
(8, 'Replace', '8', 7),
(10, 'Manjaros', '8', 7),
(11, 'Debian', '8', 7);

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
(3, 'Diseñador de interfaces', 6, 8),
(4, 'Responsable de funcionalidades', 6, 9),
(7, 'Responsable de base de datos', 6, 10),
(8, 'Responsable de vistas', 7, 11),
(9, 'Responsable de base de datos no relacionales', 7, 12),
(10, 'Responsable de funcionalidades y análisis', 7, 9);

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
(7, 0, '2017-06-26', 1);

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
(7, '2', 44);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `miembro`
--

CREATE TABLE `miembro` (
  `id` int(11) NOT NULL,
  `destrezas` varchar(100) COLLATE utf8_spanish2_ci NOT NULL,
  `estado` varchar(15) COLLATE utf8_spanish2_ci NOT NULL DEFAULT 'A',
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `miembro`
--

INSERT INTO `miembro` (`id`, `destrezas`, `estado`, `id_usuario`) VALUES
(8, '', 'A', 45),
(9, 'Android, Diseños, full stack', 'A', 46),
(10, 'Diseño de base de datos', 'A', 47),
(11, 'Diseño de interfaces', 'A', 48),
(12, 'Diseño de bases de datos no relacionales', 'A', 50),
(13, 'Desarollo de interfaces', 'A', 52);

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
(5, 'C005', 'Vizualizar el documento con una interfaz con la cual se puedan añadir observaciones', '4', 16, 6),
(9, 'C006', 'El estudiante deberá poder listar todaslas observaciones que realizó el docente pero no podrá editarlas', '4', 16, 6),
(11, 'C007', 'Estudiantes y docentes deberá poder acceder mediante un login con su correo y una contraceña', '3', 4, 6),
(12, 'C885', 'Realizar el CRUD para las observaciones de un docu..', '5', 24, 6),
(14, 'P001', 'Realizar el diseño de viguetas utilizando una librería de diseño', '5', 24, 23),
(15, 'C-001', 'Modulo de Seguridad', '5', 24, 15),
(16, 'C-002', 'Vistas de Login, animaciones y Diseño de logos', '4', 4, 15);

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
(4, 'P001', 'JScrum', 'Aplicación de software para la gestión de de trabajo utilizando el marco Scrum', 'agilizar el desarrollo', '2017-06-10 05:33:04', 'En proceso', 7, 6),
(6, 'P002', 'GitGrad', 'Aplicación de software en plataforma web para la revisión de documentos digitales', 'Optimizar el proceso de revisión de documentos de proyectos de grado', '2017-06-10 05:46:22', 'En proceso', 7, 6),
(8, 'P003', 'Lab Vos Andes', 'Sistema para la gestión de laboratorio clínico', 'Administrar con eficiencia los datos del laboratio clínico', '2017-06-10 05:47:49', 'En proceso', 7, 6),
(10, 'P011', 'Go Móvil', 'Aplicación de software de red social empresarial', 'Otorgar servicios para publicación de empresas', '2017-06-10 06:06:39', 'En proceso', 7, 7),
(12, 'P012', 'CCBOL', 'Página web para el evento de ciencias de computación de Bolivia', 'Otorgar información y servicios necesarios para la realización del evento', '2017-06-10 06:08:43', 'En proceso', 7, 8),
(13, 'P025', 'Sistema de diseño de losas de entrepiso', 'Aplicación para el diseño de losas de entrepiso unidireccionales y bidireccionales.', 'Automatizar todos los cálculos necesarios para el diseño de losas de entrepiso.', '2017-06-11 00:44:07', 'En proceso', 7, 8),
(15, 'C014', 'Aplicación para enseñar matemáticas a niños de manera lógica', 'Aplicación Android para enseñar a niños matemáticas', 'Diseñar una aplicación web que permita a niños aprender matemáticas de manera lógica', '2017-06-11 04:34:28', 'En proceso', 7, 6),
(16, 'F-01', 'Full Casas', 'Software de gestion de ventas y alquier de casa', 'Proveer al usuario un sitio completo de ofertas sobre bienes inmuebles', '2017-06-11 04:36:56', 'En proceso', 7, 7),
(18, 'Sv-01', 'SerApp', 'App para manejo de mantenimiento de vehiculos.', 'Gestionar la informacion para presentar un reporte correcto', '2017-06-11 04:48:06', 'En proceso', 7, 7),
(19, 'p-05', 'Simulacro E-AD', 'Simulacro de examen de admision', 'Plataforma web para dar simulacros del examen de admision USFX', '2017-06-11 04:53:28', 'En proceso', 7, 8),
(21, '', '', '', '', '2017-06-11 14:42:37', 'En proceso', 0, 0),
(22, 'G011', 'Noticias Sistemas', 'Aplicación Android de noticias para la carrera de Ingeniería de Sistemas', 'Notificar a los usuarios sobre todas las actividades y noticias realizadas en la carrera de Ingeniería de Sistemas', '2017-06-11 16:49:42', 'En proceso', 7, 9),
(23, 'G004', 'Software de diseño de viguetas', 'Aplicación de escritorio que permite realizar el diseño e viguetas', 'Facilitar los cálculos implicados en el diseño de viguetas', '2017-06-12 20:32:32', 'En proceso', 7, 11);

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
(3, '0', 'S0001', 'Realizar Crud de observaciones', '10', 24, 2, 6),
(6, '1.1', 'B100', 'Backlog 1', '5', 24, 2, 6),
(9, '1.2', 'B101', 'Backlog 1.2', '5', 16, 2, 6),
(10, '2', 'C555', 'Historia prueba', '5', 8, 2, 6),
(13, '0', 'P001', 'zzzzzzzzz', '5', 8, 5, 15),
(14, '0', 'P001', 'zzzzzzzzz', '5', 8, 5, 15),
(15, '2', 'C5555', 'la concha de la lora japonesa', '2', 12, 2, 15),
(17, '1', 'H-01', 'Esta historia no me Gusta', '1', 16, 2, 15),
(18, '2', '3', 'Esta es una segunda Historia', '5', 16, 2, 15),
(19, '2', 'H-02', 'Historia 2', '4', 20, 2, 15),
(20, '3', 'H-04', 'Historia 5', '5', 16, 2, 15),
(21, '2', 'fasdf', 'asdfadsf', '', 123, 2, 15),
(22, '1', 'h02', 'Cualquier Cosa', '5', 20, 2, 15),
(23, '4', 'h-05', 'Historia 5', '5', 24, 2, 15),
(24, '3', 'H-06', 'Historia Falsa', '4', 24, 2, 15),
(25, '5', 'h-0001', 'HIstoria Truecha', '4', 20, 2, 15),
(26, '6', 'h-0006', 'Otra Historia', '5', 5, 0, 0),
(27, '6', 'H-005', 'Otra Historia', '5', 5, 0, 0),
(28, '6', 'H-007', 'NInguna', '5', 15, 2, 15),
(29, '7', 'h-0012', 'No lo se', '5', 16, 0, 0),
(30, '8', 'h-0008', 'asdfas', '1', 12, 0, 0),
(31, '7', 'S-7', 'Historia 7', '5', 5, 2, 15),
(32, '8', 'H-8', 'Nueva Historia', '5', 24, 2, 15),
(33, '9', 'S-09', 'Historia 9', '1', 10, 2, 15),
(34, '10', 'S-10', 'Ultima Historia', '5', 5, 2, 15),
(35, '11', 'S-11', 'Ultima Historia', '5', 5, 2, 15),
(36, '1', 'S-01', 'Nueva Historia', '5', 5, 7, 15),
(37, '2', 'S-02', 'Nueva Historia 2', '5', 5, 7, 15),
(38, '3', 'S-3', 'Historia 3', '4', 12, 7, 15),
(39, '4', 'S-4', 'Historia 4', '3', 20, 7, 15),
(40, '5', 'S-05', 'Pollo tiene que ir al banio', '5', 1, 7, 15),
(41, '1', 'S-001', 'Nueva Historia de Pollo', '5', 12, 8, 15);

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

--
-- Volcado de datos para la tabla `seguimiento`
--

INSERT INTO `seguimiento` (`id`, `tareas_persona_pendientes`, `horas_persona_pendientes`, `fecha_seguimiento`, `id_sprint`) VALUES
(1, 4, 16, '2017-06-26', 2),
(2, 4, 16, '2017-06-26', 2),
(3, 3, 12, '2017-06-26', 2),
(4, 4, 16, '2017-06-26', 2),
(5, 3, 12, '2017-06-26', 2);

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
(2, 'S1000', 415, '2017-05-31', '2017-06-30', 4, 16, 'En proceso', 15),
(3, 'S2225', 0, '2017-06-10', '2017-09-30', 0, 0, 'En proceso', 0),
(7, 'p-001', 43, '2017-06-21', '2017-10-01', 0, 0, 'En proceso', 15),
(8, 's-01', 12, '2017-06-21', '2017-06-23', 0, 0, 'En proceso', 15),
(9, 'p-01', 0, '2017-06-21', '2017-06-24', 0, 0, 'En proceso', 15),
(10, 's001', 0, '2017-06-21', '2017-06-30', 0, 0, 'En proceso', 15);

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
(1, '1', 'A100', 'Interfaz de los niños de Kaya', 'Principal', 'Terminado', 4, 2, 11);

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
  `foto` varchar(400) COLLATE utf8_spanish2_ci NOT NULL DEFAULT '/images/user.svg'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id`, `nombre`, `apellidos`, `email`, `login`, `password`, `profesion`, `rol`, `foto`) VALUES
(41, 'erwin', 'mendez', 'erwinXYZ1@gmail.com', 'erwin', '1234', 'Estudiante', 'Administrador', 'user1.svg'),
(44, 'Soledad', 'Nina Huanca', 'solenina@gmail.com', 'sole', '1234', 'developer', 'Manager', 'user1.svg'),
(45, 'Diego', 'Escalante Antezana', 'diego@gmail.com', 'diego', '1234', 'Developer', 'Usuario', 'user1.svg'),
(46, 'Kaya', 'Negron', 'kaya@gmail.com', 'kaya', '1234', 'developer', 'Usuario', 'user1.svg'),
(47, 'Yanin', 'Oquendo', 'yanin@gmail.com', 'yanin', '1234', 'designer', 'Usuario', 'user1.svg'),
(48, 'José', 'Chirinos', 'josecito@gmail.com', 'jose', '1234', 'Ingeniero de Sistemas', 'Usuario', 'user1.svg'),
(50, 'Gary David', 'Guzman Muñoz', 'Elgary@gmail.com', 'gary', '1234', 'Ingeniero de sistemas', 'Manager', 'images/Elgary@gmail.com'),
(51, '', 'f', 'eee@gmail.com', '3', '3', '3', 'Usuario', '/images/user.svg'),
(52, 'Jeannethe', 'Miranda', 'jeannethe@gmail.com', 'jeanne', '1234', 'Contandora', 'Usuario', '/images/user.svg');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT de la tabla `equipo_miembro`
--
ALTER TABLE `equipo_miembro`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT de la tabla `esfuerzo`
--
ALTER TABLE `esfuerzo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT de la tabla `manager`
--
ALTER TABLE `manager`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT de la tabla `miembro`
--
ALTER TABLE `miembro`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT de la tabla `pila`
--
ALTER TABLE `pila`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT de la tabla `proyecto`
--
ALTER TABLE `proyecto`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;
--
-- AUTO_INCREMENT de la tabla `proyecto_sprint`
--
ALTER TABLE `proyecto_sprint`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;
--
-- AUTO_INCREMENT de la tabla `seguimiento`
--
ALTER TABLE `seguimiento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT de la tabla `sprint`
--
ALTER TABLE `sprint`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT de la tabla `tarea`
--
ALTER TABLE `tarea`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
