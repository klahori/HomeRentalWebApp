<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>Room Information</title>
	</head>
	<?php
	session_start();
	if (!isset( $_SESSION['room_id']))
	{
		exit;
	}
	$conn_string = "host=web0.eecs.uottawa.ca port = 15432 dbname=klaho028 user=klaho028 password = Khyber405";

	$dbh = pg_connect($conn_string) or die('Connection failed');

	$room_id = $_SESSION['room_id'];


		$sql = "SELECT * from project.Pricing s WHERE  s.RoomID=$1";
		$stmt = pg_prepare($dbh,"ps",$sql);
		$result = pg_execute($dbh,"ps",array($room_id));
		if(!$result){
			die("Error in SQL query:" .pg_last_error());
		}


	?>
	<body>
		<div id="header">Room  Details</div>
		<table>
			<tr>
				<th>Room ID</th>
				<th>Number of Guests</th>
			</tr>

			<?php
			$resultArr = pg_fetch_all($result);

			foreach($resultArr as $array)
			{
			    echo '<tr>
									<td>'. $array['roomid'].'</td>
									<td>'. $array['numberofguests'].'</td>
			          </tr>';
			}
			echo '</table>';
			?>

		</table>
	</body>

</html>
