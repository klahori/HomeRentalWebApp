<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" href="css/style1.css"/>
<title>Guest Reservation</title>
</head>
	<?php
	session_start();
	if (!isset( $_SESSION['property_id']))
	{
		exit;
	}
	$conn_string = "host=web0.eecs.uottawa.ca port = 15432 dbname=klaho028 user=klaho028 password = Khyber405";

			$dbconn = pg_connect($conn_string) or die('Connection failed');
			$property_id = $_SESSION['property_id'];
			
			$query1 = "set search_path to \"project\"";
			$result1 = pg_query($dbconn, $query1);
			if (!$result1) {
				echo "An error occurred.\n";
				exit;
			}
			$sql ="SELECT * from Rental_Agreement ";
			$stmt = pg_prepare($dbconn,"ps",$sql);
			$resultOrder = pg_execute($dbconn,"ps",array());
			$resultArr = pg_fetch_all($resultOrder);

			foreach($resultArr as $array)
			{
			     '<tr>
							<td>'. $orderid=$array['orderid'].'</td>	
			          </tr>';
			}
			$orderid=(int)$orderid+1;
			
			$sqlp ="SELECT * from Pricing b WHERE b.PropertyID=$1 ";
			$stmta = pg_prepare($dbconn,"ps2",$sqlp);
			$resultp = pg_execute($dbconn,"ps2",array($property_id));
			$resultArra = pg_fetch_all($resultp);

			foreach($resultArra as $array)
			{
			     '<tr>
							//<td>'. $pricingid=$array['pricingid'].'</td>	
		          </tr>';
			}
			
			$pricingid=(int)$pricingid;
			

							
		if (isset( $_POST['save'] ))
		{
			$startdate= $_POST['isdate'];
			$enddate = $_POST['iedate'];
			$signature = $_POST['isignature'];
			$signingdate = $_POST['isigningdate'];
			$guestid = $_POST['iguestid'];
			$occupancyrate= $_POST['ioccupancyrate'];
	
			$query = "INSERT INTO Rental_Agreement(OrderID ,TotalPrice ,Signature ,SigningDate,StartDate,EndDate,GuestID,PricingID,OccupancyRate ) VALUES ('$orderid','0','$signature','$signingdate','$startdate','$enddate','$guestid','$pricingid','$occupancyrate')";
			$result = pg_query($dbconn,$query);

			if(!$result){
				die("Error in SQL query:" .pg_last_error());
			}

			echo "  Reservation Made ";

			pg_free_result($result);
			pg_close($dbconn);

		}
	?>
<body>
	<div id="header"> Guest Reservation</div>
	<form id="testform" name="testform" method="POST" action="">
		<p> <label for="iguestid">Guest ID:</label>
				<input  name="iguestid" type="text" id="iguestid"/>
		</p>
		<p> <label for="isdate">Start Date:</label>
				<input value="yyyy-mm-dd" name="isdate" type="text" id="isdate"/>
		</p>
		
		<p> <label for="iedate">End Date:</label>
				<input name="iedate" type="text" id="iedate"/>
		</p>
		
		<p> <label for="ioccupancyrate">Amount of People:</label>
				<input name="ioccupancyrate" type="text" id="ioccupancyrate"/>
		</p>
		<p> <label for="isignature">Signature:</label>
				<input name="isignature" type="text" id="isignature"/>
		</p>

		<p> <label for="isigningdate">SigningDate:</label>
				<input name="isigningdate" type="text" id="isigningdate"/>
		</p>

		<p><input type="submit" value="Register" name="save" /></p>
	</form>

</body>
</html>
