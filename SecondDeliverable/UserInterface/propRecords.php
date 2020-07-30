<html>
	<head> 
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>Property Information</title>
	</head>
	<?php
	session_start();
	if (!isset( $_SESSION['vcountry'])AND !isset($_SESSION['vcity'])AND !isset($_SESSION['vprovince']  ))
	{
		exit;
	}
	$conn_string = "host=web0.eecs.uottawa.ca port = 15432 dbname=klaho028 user=klaho028 password = Khyber405";

	$dbh = pg_connect($conn_string) or die('Connection failed');
	$query1 = "set search_path to \"project\"";
	$result1 = pg_query($dbh, $query1);
	if (!$result1) {
		echo "An error occurred.\n";
		exit;
	}
	$vcountry = $_SESSION['vcountry'];
	$vcity = $_SESSION['vcity'];
	$vprovince = $_SESSION['vprovince'];

		$sql = "SELECT *,* from Property s,Pricing b WHERE s.PropertyID = b.PropertyID AND s.Rented = '0' AND s.Country=$1AND s.City = $2 AND s.Province_State=$3";
		$stmt = pg_prepare($dbh,"ps",$sql);
		$result = pg_execute($dbh,"ps",array($vcountry, $vcity,$vprovince));
		if(!$result){
			die("Error in SQL query:" .pg_last_error());
		}
	if (isset( $_POST['save'] ))
		{
			$property_id= $_POST['property_id'];
				
		$query = "SELECT * FROM Property WHERE PropertyID=$property_id";
			$result21 = pg_query($dbh,$query);

			if(!$result21){
				die("Error in SQL query:" .pg_last_error());
			}
		$row_count = pg_num_rows($result21);

		if($row_count>0){
			$_SESSION['property_id'] = $property_id;
			header("location: http://127.0.0.1/propRes.php");
			exit;
		}
		echo "No properties were found in that area";
			pg_free_result($result21);
			pg_close($dbh);

		}


	?>
	<body>
		<div id="header">Property  Details</div>
		<table>
			<tr>
				<th>Property ID</th>
				<th>Address</th>
				<th>City</th>
				<th>Province/State</th>
				<th>Country</th>
				<th>Daily Cost</th>

			</tr>

			<?php
			$resultArr = pg_fetch_all($result);

			foreach($resultArr as $array)
			{
			    echo '<tr>
									<td>'. $array['propertyid'].'</td>
									<td>'. $array['address'].'</td>
									<td>'. $array['city'].'</td>
									<td>'. $array['province_state'].'</td>
									<td>'. $array['country'].'</td>
									<td>'. $array['dailycost'].'</td>

			          </tr>';
			}
			echo '</table>';
			?>

		</table>
		
	<form id="testform" name="testform" method="POST" action="">
		
		
		<p> <label for="property_id">Property ID:</label>
				<input name="property_id" type="text" id="property_id"/>
		</p>
		
		<p><input type="submit" value="Submit" name="save" /></p>
	</form>

	</body>

</html>
