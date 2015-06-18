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
			echo "GET DATA [roadmap_projects]: Error: ".mysql_error();
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
					."\"id\": "."\"".$row['roadmap_projects_id']."\"".","
					."\"roadmap\": ["
					."{"
						."\"roadmap_projects_id\": "."\"".$row['system_users_id']."\"".","
						."\"roadmap_projects_release\": "."\"".$row['system_users_name']."\"".","
						."\"roadmap_projects_version\": "."\"".$row['system_users_login']."\"".","
						."\"roadmap_projects_name\": "."\"".$row['system_users_pass']."\"".","
						."\"roadmap_projects_link\": "."\"".$row['system_users_pass']."\"".","
						."\"roadmap_projects_dev_begin\": "."\"".$row['system_users_pass']."\"".","
						."\"roadmap_projects_dev_end\": "."\"".$row['system_users_pass']."\"".","
						."\"roadmap_projects_qa_begin\": "."\"".$row['system_users_pass']."\"".","
						."\"roadmap_projects_qa_end\": "."\"".$row['system_users_pass']."\"".","
						."\"roadmap_projects_project\": "."\"".$row['system_users_admin']."\""
					."}]}"; 
				$index++;
			}
		}
		mysql_close();
		$data_array_json .= "]";
		echo $data_array_json;
?>