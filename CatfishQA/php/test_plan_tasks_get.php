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
			echo "GET DATA [test_plan_tasks]: Error: ".mysql_error();
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
					."\"id\": "."\"".$row['test_plan_tasks_id']."\"".","
					."\"testplan\": ["
					."{"
						."\"test_plan_tasks_id\": "."\"".$row['test_plan_tasks_id']."\"".","
						."\"test_plan_tasks_testing_begin\": "."\"".$row['test_plan_tasks_testing_begin']."\"".","
						."\"test_plan_tasks_name\": "."\"".$row['test_plan_tasks_name']."\"".","
						."\"test_plan_tasks_link\": "."\"".$row['test_plan_tasks_link']."\"".","
						."\"test_plan_tasks_create_test_case_qa\": "."\"".$row['test_plan_tasks_create_test_case_qa']."\"".","
						."\"test_plan_tasks_testing_qa\": "."\"".$row['test_plan_tasks_testing_qa']."\"".","
						."\"test_plan_tasks_link_test_case\": "."\"".$row['test_plan_tasks_link_test_case']."\"".","
						."\"test_plan_tasks_result_android\": "."\"".$row['test_plan_tasks_result_android']."\"".","
						."\"test_plan_tasks_result_ios\": "."\"".$row['test_plan_tasks_result_ios']."\"".","
						."\"test_plan_tasks_result_web\": "."\"".$row['test_plan_tasks_result_web']."\"".","
						."\"test_plan_tasks_sprint_id\": "."\"".$row['test_plan_tasks_sprint_id']."\""
					."}]}"; 
				$index++;
			}
		}
		mysql_close();
		$data_array_json .= "]";
		echo $data_array_json;
	}
?>