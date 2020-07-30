<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Guest Database</title>
</head>
<?php
	session_start();
	if (isset( $_POST['login'] ))
	{
		$ssn_id = $_POST['ssn_id'];
		$emppassword = $_POST['emppassword'];

		$conn_string = "host=web0.eecs.uottawa.ca port = 15432 dbname=klaho028 user=klaho028 password = Khyber405";

		$dbconn = pg_connect($conn_string) or die('Connection failed');

		$query = "SELECT * FROM project.Employee WHERE SSN = $1 AND HashedPassword =$2";

		$stmt = pg_prepare($dbconn,"ps",$query);
		$result = pg_execute($dbconn,"ps",array($ssn_id,$emppassword));

		if(!$result){
			die("Error in SQL query:" .pg_last_error());
		}

		$row_count = pg_num_rows($result);

		if($row_count>0){
			$_SESSION['ssn_id'] = $ssn_id;
			header("location: http://127.0.0.1/pickProp.php");
			exit;
		}
		echo "Incorrect Information";

		pg_free_result($result);
		pg_close($dbconn);
	}
?>
<body>
	<div id="header"> Employee LOGIN FORM</div>
	<form method="POST" action="">
		<p>SSN #: <input type="text" name="ssn_id" id="ssn_id"/></p>
		<p>Password: <input type="password" name="emppassword" id="emppassword" /></p>
		<p><input type="submit" value="login" name="login" /></p>
	</form>

</body>
</html>
