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
					."\"id\": "."\"".$row['roadmap_sprints_id']."\"".","
					."\"roadmap\": ["
					."{"
						."\"roadmap_sprints_id\": "."\"".$row['roadmap_sprints_id']."\"".","
						."\"roadmap_sprints_name\": "."\"".$row['roadmap_sprints_name']."\"".","
						."\"roadmap_sprints_date\": "."\"".$row['roadmap_sprints_date']."\"".","
						."\"roadmap_sprints_project\": "."\"".$row['roadmap_sprints_project']."\""
					."}]}"; 
				$index++;
			}
		}
		mysql_close();
		$data_array_json .= "]";
		echo $data_array_json;
	}
?>