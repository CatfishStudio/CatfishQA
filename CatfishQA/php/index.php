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
				system_users_name varchar(255) NOT NULL,
				system_users_login varchar(255) NOT NULL,
				system_users_pass varchar(255) NOT NULL,
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
				team_groups_name varchar(255) NOT NULL,
				team_groups_link_project varchar(255) NOT NULL,
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
			
			
			/*Создание таблицы Проекты и поманды (team_users) ============== */
			$query = mysql_query("CREATE TABLE team_users (
				team_users_id int(5) NOT NULL AUTO_INCREMENT,
				team_users_name varchar(255) NOT NULL,
				team_users_login varchar(255) NOT NULL,
				team_users_rights varchar(1) NOT NULL DEFAULT 'r',
				team_users_groups_name varchar(255) NOT NULL,
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
			
			/*Создание таблицы Роадмап (roadmap_sprints) ============== */
			$query = mysql_query("CREATE TABLE roadmap_sprints (
				roadmap_sprints_id int(8) NOT NULL AUTO_INCREMENT,
				roadmap_sprints_date datetime NOT NULL,
				roadmap_sprints_name varchar(255) NOT NULL,
				roadmap_sprints_project varchar(255) NOT NULL,
				PRIMARY KEY (roadmap_sprints_id)
			)", $db);
			/* Проверка успешности выполнения */
			if(!$query){
				echo "<br><br>ERROR!!! Table \"roadmap_sprints\" - error! ";
				echo "<br><br>Error: ", mysql_error();
				$query = mysql_query("DROP DATABASE ".$database, $db);
				exit;
			}else{
				echo "<br><br>Create table \"roadmap_sprints\" - complete!";
			}
			
			$query = mysql_query("CREATE TABLE roadmap_tasks (
				roadmap_tasks_id int(8) NOT NULL AUTO_INCREMENT,
				roadmap_tasks_release datetime NOT NULL,
				roadmap_tasks_version varchar(255) NOT NULL,
				roadmap_tasks_name varchar(255) NOT NULL,
				roadmap_tasks_link varchar(255) NOT NULL,
				roadmap_tasks_dev_begin datetime NOT NULL,
				roadmap_tasks_dev_end datetime NOT NULL,
				roadmap_tasks_qa_begin datetime NOT NULL,
				roadmap_tasks_qa_end datetime NOT NULL,
				roadmap_tasks_sprint_id varchar(255) NOT NULL,
				PRIMARY KEY (roadmap_tasks_id)
			)", $db);
			/* Проверка успешности выполнения */
			if(!$query){
				echo "<br><br>ERROR!!! Table \"roadmap_tasks\" - error! ";
				echo "<br><br>Error: ", mysql_error();
				$query = mysql_query("DROP DATABASE ".$database, $db);
				exit;
			}else{
				echo "<br><br>Create table \"roadmap_tasks\" - complete!";
			}
			/*==================================================================*/
			
			
			/*Создание таблицы Тест-план (test_plan_sprints) ============== */
			$query = mysql_query("CREATE TABLE test_plan_sprints (
				test_plan_sprints_id int(8) NOT NULL AUTO_INCREMENT,
				test_plan_sprints_date datetime NOT NULL,
				test_plan_sprints_name varchar(255) NOT NULL,
				test_plan_sprints_project varchar(255) NOT NULL,
				PRIMARY KEY (test_plan_sprints_id)
			)", $db);
			/* Проверка успешности выполнения */
			if(!$query){
				echo "<br><br>ERROR!!! Table \"test_plan_sprints\" - error! ";
				echo "<br><br>Error: ", mysql_error();
				$query = mysql_query("DROP DATABASE ".$database, $db);
				exit;
			}else{
				echo "<br><br>Create table \"test_plan_sprints\" - complete!";
			}
			
			$query = mysql_query("CREATE TABLE test_plan_tasks (
				test_plan_tasks_id int(8) NOT NULL AUTO_INCREMENT,
				test_plan_tasks_testing_begin datetime NOT NULL,
				test_plan_tasks_name varchar(255) NOT NULL,
				test_plan_tasks_link varchar(255) NOT NULL,
				test_plan_tasks_create_test_case_qa varchar(255) NOT NULL,
				test_plan_tasks_testing_qa varchar(255) NOT NULL,
				test_plan_tasks_link_test_case int(10),
				test_plan_tasks_result_android varchar(50) NOT NULL,
				test_plan_tasks_result_ios varchar(50) NOT NULL,
				test_plan_tasks_result_web varchar(50) NOT NULL,
				test_plan_tasks_sprint_id varchar(255) NOT NULL,
				PRIMARY KEY (test_plan_tasks_id)
			)", $db);
			/* Проверка успешности выполнения */
			if(!$query){
				echo "<br><br>ERROR!!! Table \"test_plan_tasks\" - error! ";
				echo "<br><br>Error: ", mysql_error();
				$query = mysql_query("DROP DATABASE ".$database, $db);
				exit;
			}else{
				echo "<br><br>Create table \"test_plan_tasks\" - complete!";
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
				(3, 'team_users', '".date("Y-m-d H:i:s")."'),
				(4, 'roadmap_sprints', '".date("Y-m-d H:i:s")."'),
				(5, 'roadmap_tasks', '".date("Y-m-d H:i:s")."'),
				(6, 'test_plan_sprints', '".date("Y-m-d H:i:s")."'),
				(7, 'test_plan_tasks', '".date("Y-m-d H:i:s")."')", $db);
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