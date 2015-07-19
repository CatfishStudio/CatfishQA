<?php
	$client = $_GET['client'];
	$tableName = $_GET['tableName'];
	
	if($client == "JGH37VB900D0IJ9D7VA027BA6")
	{
		include "config.php";
		
		$db = mysql_connect($server, $uid, $pass);
		mysql_select_db($database,$db);
		$query = mysql_query("SELECT * FROM history_update WHERE (history_update_name = '".$tableName."')", $db);
		
		if(!$query) 
		{
			echo "GET DATA [history_update]: Error: ".mysql_error();
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
					."\"id\": "."\"".$row['history_update_id']."\"".","
					."\"table\": ["
					."{"
						."\"history_update_id\": "."\"".$row['history_update_id']."\"".","
						."\"history_update_name\": "."\"".$row['history_update_name']."\"".","
						."\"history_update_datetime\": "."\"".$row['history_update_datetime']."\""
					."}]}"; 
				$index++;
			}
		
		}
		
		mysql_close();
		$data_array_json .= "]";
		echo $data_array_json;
	}
?>