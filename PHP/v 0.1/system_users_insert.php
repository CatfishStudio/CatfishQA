<?php
	$client = $_GET['client'];
	$system_users_name = $_GET['system_users_name'];
	$system_users_login = $_GET['system_users_login'];
	$system_users_pass = $_GET['system_users_pass'];
	$system_users_admin = $_GET['system_users_admin'];
	
	if($client == 1)
	{
		include "config.php";

		$db = mysql_connect($server, $uid, $pass);
		mysql_select_db($database,$db);
		$query = mysql_query("INSERT INTO system_users (system_users_name, system_users_login, system_users_pass, system_users_admin) VALUES
			('".$system_users_name."',
			'".$system_users_login."', 
			'".$system_users_pass."', 
			'".$system_users_admin."')", $db);
	
		if(!$query) 
		{
			echo "Insert [system_users]: Error: ".mysql_error();
			mysql_close();
			exit;
		}else {
			$query = mysql_query("UPDATE history_update SET history_update_datetime = '".date("Y-m-d H:i:s")."' WHERE history_update_id = 1", $db);
			if(!$query) 
			{
				echo "Update [history_update]: Error: ".mysql_error();
				mysql_close();
				exit;
			}else {
				echo "complete";
			}
		}
		mysql_close();
	}
?>
