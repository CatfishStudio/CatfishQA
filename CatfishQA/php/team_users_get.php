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
			echo "GET DATA [team_users]: Error: ".mysql_error();
			mysql_close();
			exit;
		}else {
	
			$index = 0;
			$data_array_json = "[";
		
			while($row = mysql_fetch_array($query))
			{
				if ($index > 0) $data_array_json .= ",{";
				else $data_array_json .= "{";

				$data_array_json .= ""
					."\"id\": "."\"".$row['team_users_id']."\"".","
					."\"team\": ["
					."{"
						."\"team_users_id\": "."\"".$row['team_users_id']."\"".","
						."\"team_users_name\": "."\"".$row['team_users_name']."\"".","
						."\"team_users_login\": "."\"".$row['team_users_login']."\"".","
						."\"team_users_rights\": "."\"".$row['team_users_rights']."\"".","
						."\"team_users_groups_name\": "."\"".$row['team_users_groups_name']."\""
					."}]}"; 
				$index++;
			}
		}
		mysql_close();
		$data_array_json .= "]";
		echo $data_array_json;
	}
?>