<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>ТЕМА ОТ CATFISH STUDIO</title>
</head>
<body>
<?php
	$db = mysql_connect("mysql.hostinger.ru", "u869575599_admin", "5553212");
	mysql_select_db("u869575599_myqab",$db);
	$result = mysql_query("SELECT * FROM system_users", $db);

	while($row = mysql_fetch_array($result)){
		echo $row['system_users_name']."<br />";
	}

	mysql_close();


?>
</body>
</html>