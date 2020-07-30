<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Property Database</title>
</head>
<?php
	session_start();
	if (isset( $_POST['Search'] ))
	{
		$property_ID = $_POST['property_ID'];

		$conn_string = "host=web0.eecs.uottawa.ca port = 15432 dbname=klaho028 user=klaho028 password = Khyber405";

		$dbconn = pg_connect($conn_string) or die('Connection failed');

		$query = "SELECT * From project.Property WHERE PropertyID = $1";

		$stmt = pg_prepare($dbconn,"ps",$query);
		$result = pg_execute($dbconn,"ps",array($property_ID));

		if(!$result){
			die("Error in SQL query:" .pg_last_error());
		}

		$row_count = pg_num_rows($result);

		if($row_count>0){
			$_SESSION['property_ID'] = $property_ID;
			header("location: http://127.0.0.1/recordsProp.php");
			exit;
		}
		echo "Data Successfully Entere, However Porperty not found  make sure correct Property ID was entered";

		pg_free_result($result);
		pg_close($dbconn);
	}
?>
<body>
	<div id="header"> Property search</div>
	<form method="POST" action="">
		<p>Property ID : <input type="text" name="property_ID" id="property_ID"/></p>
		<p><input type="submit" value="Search" name="Search" /></p>
	</form>

</body>
</html>
