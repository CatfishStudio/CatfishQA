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
			echo "GET DATA [test_plan_sprints]: Error: ".mysql_error();
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
					."\"id\": "."\"".$row['test_plan_sprints_id']."\"".","
					."\"testplane\": ["
					."{"
						."\"test_plan_sprints_id\": "."\"".$row['test_plan_sprints_id']."\"".","
						."\"test_plan_sprints_name\": "."\"".$row['test_plan_sprints_name']."\"".","
						."\"test_plan_sprints_date\": "."\"".$row['test_plan_sprints_date']."\"".","
						."\"test_plan_sprints_project\": "."\"".$row['test_plan_sprints_project']."\""
					."}]}"; 
				$index++;
			}
		}
		mysql_close();
		$data_array_json .= "]";
		echo $data_array_json;
	}
?>