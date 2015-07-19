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
			echo "GET DATA [team_groups]: Error: ".mysql_error();
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
					."\"id\": "."\"".$row['team_groups_id']."\"".","
					."\"team\": ["
					."{"
						."\"team_groups_id\": "."\"".$row['team_groups_id']."\"".","
						."\"team_groups_name\": "."\"".$row['team_groups_name']."\"".","
						."\"team_groups_link_project\": "."\"".$row['team_groups_link_project']."\""
					."}]}"; 
				$index++;
			}
		}
		mysql_close();
		$data_array_json .= "]";
		echo $data_array_json;
	}
?>