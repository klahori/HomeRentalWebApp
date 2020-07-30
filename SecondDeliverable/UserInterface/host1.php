<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Host Property posting</title>
</head>
<?php
	session_start();
	if (isset( $_POST['continue'] ))
	{
		$vcountry = $_POST['vcountry'];


		$conn_string = "host=web0.eecs.uottawa.ca port = 15432 dbname=klaho028 user=klaho028 password = Khyber405";

		$dbconn = pg_connect($conn_string) or die('Connection failed');

		$query = "SELECT * FROM project.Branch WHERE  Country=$1";

		$stmt = pg_prepare($dbconn,"ps",$query);
		$result = pg_execute($dbconn,"ps",array($vcountry));

		if(!$result){
			die("Error in SQL query:" .pg_last_error());
		}

		$row_count = pg_num_rows($result);

		if($row_count>0){
			$_SESSION['vcountry'] = $vcountry;
			header("location: http://127.0.0.1/host.php");
			exit;
		}
		echo "No service in this country";

		pg_free_result($result);
		pg_close($dbconn);
	}
?>
<body>
	<div id="header">  Property Posting</div>
	<form method="POST" action="">
		<p>Country : <input type="text" name="vcountry" id="vcountry"/></p>

		<p><input type="submit" value="continue" name="continue" /></p>
	</form>
	

</body>
</html>
