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
			echo "GET DATA [roadmap_tasks]: Error: ".mysql_error();
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
					."\"id\": "."\"".$row['roadmap_tasks_id']."\"".","
					."\"roadmap\": ["
					."{"
						."\"roadmap_tasks_id\": "."\"".$row['roadmap_tasks_id']."\"".","
						."\"roadmap_tasks_release\": "."\"".$row['roadmap_tasks_release']."\"".","
						."\"roadmap_tasks_version\": "."\"".$row['roadmap_tasks_version']."\"".","
						."\"roadmap_tasks_name\": "."\"".$row['roadmap_tasks_name']."\"".","
						."\"roadmap_tasks_link\": "."\"".$row['roadmap_tasks_link']."\"".","
						."\"roadmap_tasks_dev_begin\": "."\"".$row['roadmap_tasks_dev_begin']."\"".","
						."\"roadmap_tasks_dev_end\": "."\"".$row['roadmap_tasks_dev_end']."\"".","
						."\"roadmap_tasks_qa_begin\": "."\"".$row['roadmap_tasks_qa_begin']."\"".","
						."\"roadmap_tasks_qa_end\": "."\"".$row['roadmap_tasks_qa_end']."\"".","
						."\"roadmap_tasks_sprint_id\": "."\"".$row['roadmap_tasks_sprint_id']."\""
					."}]}"; 
				$index++;
			}
		}
		mysql_close();
		$data_array_json .= "]";
		echo $data_array_json;
	}
?>