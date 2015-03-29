<?php
	$client = $_GET['client'];
	$sqlcommand = $_GET['sqlcommand'];
	
	if($client == 1)
	{
		include "config.php";

		$db = mysql_connect($server, $uid, $pass);
		mysql_select_db($database,$db);
		$query = mysql_query($sqlcommand, $db);
	
		if(!$query) 
		{
			echo "SET DATA [team_groups]: Error: ".mysql_error();
			mysql_close();
			exit;
		}else {
			$query = mysql_query("UPDATE history_update SET history_update_datetime = '".date("Y-m-d H:i:s")."' WHERE history_update_id = 2", $db);
			if(!$query) 
			{
				echo "UPDATE [history_update]: Error: ".mysql_error();
				mysql_close();
				exit;
			}else {
				echo "complete";
			}
		}
		mysql_close();
	}
?>