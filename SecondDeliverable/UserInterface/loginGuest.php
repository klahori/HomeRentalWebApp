<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Guest Database</title>
</head>
<?php
	session_start();
	if (isset( $_POST['login'] ))
	{
		$guest_id = $_POST['guest_id'];
		$guestpassword = $_POST['guestpassword'];

		$conn_string = "host=web0.eecs.uottawa.ca port = 15432 dbname=klaho028 user=klaho028 password = Khyber405";

		$dbconn = pg_connect($conn_string) or die('Connection failed');

		$query = "SELECT * FROM project.Guest WHERE GuestID = $1 AND HashedPassword =$2";

		$stmt = pg_prepare($dbconn,"ps",$query);
		$result = pg_execute($dbconn,"ps",array($guest_id,$guestpassword));

		if(!$result){
			die("Error in SQL query:" .pg_last_error());
		}

		$row_count = pg_num_rows($result);

		if($row_count>0){
			$_SESSION['guest_id'] = $guest_id;
			header("location: http://127.0.0.1/guest.php");
			exit;
		}
		echo "Wrong information try again or Register";

		pg_free_result($result);
		pg_close($dbconn);
	}
?>
<body>
	<div id="header"> Guest LOGIN FORM</div>
	<form method="POST" action="">
		<p>Guest ID #: <input type="text" name="guest_id" id="guest_id"/></p>
		<p>Password: <input type="password" name="guestpassword" id="guestpassword" /></p>
		<p><input type="submit" value="login" name="login" /></p>
	</form>
	<a href="pickRegister.php">Register</a>

</body>
</html>
