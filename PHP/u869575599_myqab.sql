
-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Хост: localhost
-- Время создания: Мар 23 2015 г., 12:17
-- Версия сервера: 5.1.71
-- Версия PHP: 5.2.17

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `u869575599_myqab`
--

-- --------------------------------------------------------

--
-- Структура таблицы `system_users`
--

CREATE TABLE IF NOT EXISTS `system_users` (
  `system_users_id` int(2) NOT NULL AUTO_INCREMENT,
  `system_users_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `system_users_login` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `system_users_pass` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `system_users_admin` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`system_users_id`),
  UNIQUE KEY `system_users_login` (`system_users_login`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=3 ;

--
-- Дамп данных таблицы `system_users`
--

INSERT INTO `system_users` (`system_users_id`, `system_users_name`, `system_users_login`, `system_users_pass`, `system_users_admin`) VALUES
(1, 'Администратор', 'Администратор', 'admin', 1),
(2, 'Пользователь', 'Пользователь', 'user', 0);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
