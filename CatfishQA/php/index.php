<?php
	$server = $_POST['server'];
	$uid = $_POST['uid'];
	$pass = $_POST['pass'];
	$database = $_POST['database'];
	
	$create = $_GET['create'];
	
	if($create == null)
	{
		echo "<h1>Information system QA</h1>";
		echo "<h2>Create database:</h2>";
		echo "<form action='index.php?create=database' method='post'>";
		echo "<label for='server'>Server:</label><br><input type='text' name='server' id='server' value='localhost'><br>";
		echo "<label for='database'>Database:</label><br><input type='text' name='database' id='database' value='qa'><br>";
		echo "<label for='Uid'>uid:</label><br><input type='text' name='uid' id='uid' value='root'><br>";
		echo "<label for='pass'>Pass:</label><br><input type='password' name='pass' id='pass' value=''><br>";
		echo "<br><input type='submit' value='Create database' id='bottonGo'>";
		echo "</form>";
		echo "<br><br>";
		echo "<h2>Create tables:</h2>";
		echo "<form action='index.php?create=tables' method='post'>";
		echo "<label for='server'>Server:</label><br><input type='text' name='server' id='server' value='localhost'><br>";
		echo "<label for='database'>Database:</label><br><input type='text' name='database' id='database' value='qa'><br>";
		echo "<label for='Uid'>uid:</label><br><input type='text' name='uid' id='uid' value='root'><br>";
		echo "<label for='pass'>Pass:</label><br><input type='password' name='pass' id='pass' value=''><br>";
		echo "<br><input type='submit' value='Create tables' id='bottonGo'>";
		echo "</form>";
	}else{
	
		if($create == "database")
		{
			/* Соединение с сервером баз данных */
			$db = mysql_connect($server, $uid, $pass);
			/* Запрос на создание базы данных  */
			$query = mysql_query("CREATE DATABASE ".$database, $db);
			/* Проверка успешности выполнения */
			if(!$query){
				echo "<br><br>ERROR!!! Database not create!";
				exit;
			}else{
				echo "<br><br>Database created!";
			}
			
			echo "<br><br>";
			echo "<form action='index.php' method='post'>";
			echo "<input type='submit' value='Back' id='back'>";
			echo "</form>";
		}
		/*--------------------------------------------------*/
		
		if($create == "tables")
		{
			/* Соединение с сервером баз данных */
			$db = mysql_connect($server, $uid, $pass);
			/*Соединение с базой данных*/
			mysql_select_db($database, $db);
		
			/*Создание таблицы Системные пользователи (system_users) ========= */
			$query = mysql_query("CREATE TABLE system_users (
				system_users_id int(3) NOT NULL AUTO_INCREMENT,
				system_users_name varchar(255) COLLATE utf8_unicode_ci NOT NULL,
				system_users_login varchar(255) COLLATE utf8_unicode_ci NOT NULL,
				system_users_pass varchar(255) COLLATE utf8_unicode_ci NOT NULL,
				system_users_admin int(1) NOT NULL DEFAULT '0',
				PRIMARY KEY (system_users_id),
				UNIQUE KEY system_users_login (system_users_login)
			)", $db);
			/* Проверка успешности выполнения */
			if(!$query){
				echo "<br><br>ERROR!!! Table \"system_users\" - error! ";
				echo "<br><br>Error: ", mysql_error();
				$query = mysql_query("DROP DATABASE ".$database, $db);
				exit;
			}else{
				echo "<br><br>Create table \"system_users\" - complete!";
			}
		
			$query = mysql_query("INSERT INTO system_users (system_users_id, system_users_name, system_users_login, system_users_pass, system_users_admin) VALUES
				(1, 'Администратор', 'Администратор', 'admin', 1),
				(2, 'Пользователь', 'Пользователь', 'user', 0)", $db);
			/* Проверка успешности выполнения */
			if(!$query){
				echo "<br><br>ERROR!!! Add item in table \"system_users\" - error! ";
				echo "<br><br>Error: ", mysql_error();
				$query = mysql_query("DROP DATABASE ".$database, $db);
				exit;
			}else{
				echo "<br><br>Add item in table \"system_users\" - complete!";
			}
			/*==================================================================*/
	
			
			/*Создание таблицы Команда Группы (team_groups) =================== */
			$query = mysql_query("CREATE TABLE team_groups (
				team_groups_id int(3) NOT NULL AUTO_INCREMENT,
				team_groups_name varchar(255) COLLATE utf8_unicode_ci NOT NULL,
				PRIMARY KEY (team_groups_id),
				UNIQUE KEY team_groups_name (team_groups_name)
			)", $db);
			/* Проверка успешности выполнения */
			if(!$query){
				echo "<br><br>ERROR!!! Table \"team_groups\" - error! ";
				echo "<br><br>Error: ", mysql_error();
				$query = mysql_query("DROP DATABASE ".$database, $db);
				exit;
			}else{
				echo "<br><br>Create table \"team_groups\" - complete!";
			}
			/*==================================================================*/
			
			
			/*Создание таблицы Команда Пользователи (team_users) ============== */
			$query = mysql_query("CREATE TABLE team_users (
				team_users_id int(5) NOT NULL AUTO_INCREMENT,
				team_users_name varchar(255) COLLATE utf8_unicode_ci NOT NULL,
				team_users_login varchar(255) COLLATE utf8_unicode_ci NOT NULL,
				team_users_rights varchar(1) NOT NULL DEFAULT 'r',
				team_users_groups_name varchar(255) COLLATE utf8_unicode_ci NOT NULL,
				PRIMARY KEY (team_users_id)
			)", $db);
			/* Проверка успешности выполнения */
			if(!$query){
				echo "<br><br>ERROR!!! Table \"team_users\" - error! ";
				echo "<br><br>Error: ", mysql_error();
				$query = mysql_query("DROP DATABASE ".$database, $db);
				exit;
			}else{
				echo "<br><br>Create table \"team_users\" - complete!";
			}
			/*==================================================================*/
			
			
			
	
			/*Создание таблицы История обновлений (history_update) ================================= */
			$query = mysql_query("CREATE TABLE history_update (
				history_update_id int(2) NOT NULL AUTO_INCREMENT,
				history_update_name varchar(255) COLLATE utf8_unicode_ci NOT NULL,
				history_update_datetime varchar(255) COLLATE utf8_unicode_ci NOT NULL,
				PRIMARY KEY (history_update_id),
				UNIQUE KEY history_update_name (history_update_name)
			)", $db);
			/* Проверка успешности выполнения */
			if(!$query){
				echo "<br><br>ERROR!!! Table \"history_update\" - error! ";
				echo "<br><br>Error: ", mysql_error();
				$query = mysql_query("DROP DATABASE ".$database, $db);
				exit;
			}else{
				echo "<br><br>Create table \"history_update\" - complete!";
			}
		
			$query = mysql_query("INSERT INTO history_update (history_update_id, history_update_name, history_update_datetime) VALUES
				(1, 'system_users', '".date("Y-m-d H:i:s")."'),
				(2, 'team_groups', '".date("Y-m-d H:i:s")."'),
				(3, 'team_users', '".date("Y-m-d H:i:s")."')", $db);
			/* Проверка успешности выполнения */
			if(!$query){
				echo "<br><br>ERROR!!! Add item in table \"history_update\" - error! ";
				echo "<br><br>Error: ", mysql_error();
				$query = mysql_query("DROP DATABASE ".$database, $db);
				exit;
			}else{
				echo "<br><br>Add item in table \"history_update\" - complete!";
			}
			/*==================================================================*/
			
			
			
			echo "<br><br>";
			echo "<form action='index.php' method='post'>";
			echo "<input type='submit' value='Back' id='back'>";
			echo "</form>";
		}
	}
?>