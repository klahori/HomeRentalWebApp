<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Room Database</title>
</head>
<?php
	session_start();
	if (isset( $_POST['Search'] ))
	{
		$room_id = $_POST['room_id'];

		$conn_string = "host=web0.eecs.uottawa.ca port = 15432 dbname=klaho028 user=klaho028 password = Khyber405";

		$dbconn = pg_connect($conn_string) or die('Connection failed');

		$query = "SELECT * From project.Pricing WHERE RoomID = $1";

		$stmt = pg_prepare($dbconn,"ps",$query);
		$result = pg_execute($dbconn,"ps",array($room_id));

		if(!$result){
			die("Error in SQL query:" .pg_last_error());
		}

		$row_count = pg_num_rows($result);

		if($row_count>0){
			$_SESSION['room_id'] = $room_id;
			header("location: http://127.0.0.1/recordsRoom.php");
			exit;
		}
		echo "Data Successfully Entere, However Room not found  make sure correct Room ID was entered";

		pg_free_result($result);
		pg_close($dbconn);
	}
?>
<body>
	<div id="header"> Room search</div>
	<form method="POST" action="">
		<p>Room ID : <input type="text" name="room_id" id="room_id"/></p>
		<p><input type="submit" value="Search" name="Search" /></p>
	</form>

</body>
</html>

