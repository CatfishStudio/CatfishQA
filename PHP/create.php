<?php
	$server = $_POST['server'];
	$uid = $_POST['uid'];
	$pass = $_POST['pass'];
	$database = $_POST['database'];
	
	if($server == null)
	{
		echo "<form action='create.php' method='post'>";
		echo "<label for='server'>Server:</label><br><input type='text' name='server' id='server' value='localhost'><br>";
		echo "<label for='database'>Database:</label><br><input type='text' name='database' id='database' value='catfishqa'><br>";
		echo "<br><label for='Uid'>uid:</label><br><input type='text' name='uid' id='uid' value='root'><br>";
		echo "<label for='pass'>Pass:</label><br><input type='password' name='pass' id='pass' value=''><br>";
		echo "<br><input type='submit' value='Create' id='bottonGo'>";
		echo "</form>";
	}else{
	
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
		/*--------------------------------------------------*/
	
		/*Соединение с базой данных*/
		mysql_select_db($database, $db);
		
		/*Создание таблицы Кафедры (chairs) ================================= */
		$query = mysql_query("CREATE TABLE system_users (
			system_users_id int(2) NOT NULL AUTO_INCREMENT,
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
	
	
	
	
		echo "<br><br>Configuration created!";
	}
?>