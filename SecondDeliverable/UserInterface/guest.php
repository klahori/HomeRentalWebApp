<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Guest Database</title>
</head>
<?php
	session_start();
	if (isset( $_POST['Search'] ))
	{
		$vcity = $_POST['vcity'];
		$vcountry = $_POST['vcountry'];
		$vprovince = $_POST['vprovince'];

		$conn_string = "host=web0.eecs.uottawa.ca port = 15432 dbname=klaho028 user=klaho028 password = Khyber405";

		$dbconn = pg_connect($conn_string) or die('Connection failed');

		$query = "SELECT * FROM project.Property WHERE City = $1 AND Country=$2 AND Province_State =$3";

		$stmt = pg_prepare($dbconn,"ps",$query);
		$result = pg_execute($dbconn,"ps",array($vcity,$vcountry,$vprovince));

		if(!$result){
			die("Error in SQL query:" .pg_last_error());
		}

		$row_count = pg_num_rows($result);

		if($row_count>0){
			$_SESSION['vcity'] = $vcity;
			$_SESSION['vcountry'] = $vcountry;
			$_SESSION['vprovince'] = $vprovince;
			header("location: http://127.0.0.1/propRecords.php");
			exit;
		}
		echo "No properties were found in that area";

		pg_free_result($result);
		pg_close($dbconn);
	}
?>
<body>
	<div id="header"> Guest search</div>
	<form method="POST" action="">
		<p>City : <input type="text" name="vcity" id="vcity"/></p>
		<p>Ptovince/State : <input type="text" name="vprovince" id="vprovince"/></p>
		<p>Country : <input type="text" name="vcountry" id="vcountry"/></p>

		<p><input type="submit" value="Search" name="Search" /></p>
	</form>
	

</body>
</html>
