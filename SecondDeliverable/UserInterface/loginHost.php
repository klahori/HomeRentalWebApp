<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Guest Database</title>
</head>
<?php
	session_start();
	if (isset( $_POST['login'] ))
	{
		$host_id = $_POST['host_id'];
		$hostpassword = $_POST['hostpassword'];

		$conn_string = "host=web0.eecs.uottawa.ca port = 15432 dbname=klaho028 user=klaho028 password = Khyber405";

		$dbconn = pg_connect($conn_string) or die('Connection failed');

		$query = "SELECT * FROM project.Host WHERE HostID = $1 AND HashedPassword =$2";

		$stmt = pg_prepare($dbconn,"ps",$query);
		$result = pg_execute($dbconn,"ps",array($host_id,$hostpassword));

		if(!$result){
			die("Error in SQL query:" .pg_last_error());
		}

		$row_count = pg_num_rows($result);

		if($row_count>0){
			$_SESSION['host_id'] = $host_id;
			header("location: http://127.0.0.1/host1.php");
			exit;
		}
		echo "Wrong information try again or Register";

		pg_free_result($result);
		pg_close($dbconn);
	}
?>
<body>
	<div id="header"> Host LOGIN FORM</div>
	<form method="POST" action="">
		<p>Host ID #: <input type="text" name="host_id" id="host_id"/></p>
		<p>Password: <input type="password" name="hostpassword" id="hostpassword" /></p>
		<p><input type="submit" value="login" name="login" /></p>
	</form>
	<a href="pickRegister.php">Register</a>

</body>
</html>
