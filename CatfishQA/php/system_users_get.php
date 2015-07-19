<?php
	$client = $_GET['client'];
	$sqlcommand = $_GET['sqlcommand'];
	
	if($client == "JGH37VB900D0IJ9D7VA027BA6")
	{
		include "config.php";

		$db = mysql_connect($server, $uid, $pass);
		mysql_select_db($database,$db);
		$query = mysql_query($sqlcommand, $db);
	
		if(!$query) 
		{
			echo "GET DATA [system_users]: Error: ".mysql_error();
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
					."\"id\": "."\"".$row['system_users_id']."\"".","
					."\"user\": ["
					."{"
						."\"system_users_id\": "."\"".$row['system_users_id']."\"".","
						."\"system_users_name\": "."\"".$row['system_users_name']."\"".","
						."\"system_users_login\": "."\"".$row['system_users_login']."\"".","
						."\"system_users_pass\": "."\"".$row['system_users_pass']."\"".","
						."\"system_users_admin\": "."\"".$row['system_users_admin']."\""
					."}]}"; 
				$index++;
			}
		}
		mysql_close();
		$data_array_json .= "]";
		echo $data_array_json;
	}
?>
