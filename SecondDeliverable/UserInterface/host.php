<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" href="css/style1.css"/>
<title>Property Posting</title>
</head>
	<?php
	session_start();
	if (!isset( $_SESSION['vcountry']))
	{
		exit;
	}
	$conn_string = "host=web0.eecs.uottawa.ca port = 15432 dbname=klaho028 user=klaho028 password = Khyber405";

			$dbconn = pg_connect($conn_string) or die('Connection failed');
			$vcountry = $_SESSION['vcountry'];
			
			$sql ="SELECT s.PropertyID from project.Property s ";
			$stmt = pg_prepare($dbconn,"ps",$sql);
			$resultprop = pg_execute($dbconn,"ps",array());
			$resultArr = pg_fetch_all($resultprop);

			foreach($resultArr as $array)
			{
			     '<tr>
							<td>'. $propertyid=$array['propertyid'].'</td>	
			          </tr>';
			}
			$propertyid=(int)$propertyid+1;
			echo 'Your Property ID number is ' ,$propertyid, ' do write this down as you will may need it'; 
			$sqlbranch ="SELECT b.BranchNumber from project.Branch b WHERE b.Country=$1 ";
			$stmtbranch = pg_prepare($dbconn,"ps1",$sqlbranch);
			$resultBranch = pg_execute($dbconn,"ps1",array($vcountry));
			$resultArr1 = pg_fetch_all($resultBranch);

			foreach($resultArr1 as $array1)
			{
			     '<tr>
							<td>'. $branchnumber=$array1['branchnumber'].'</td>	
			          </tr>';
			}
			$branchnumber=(int)$branchnumber;
			
		
		$sqlmanager ="SELECT b.Manager_SSN from project.Branch b WHERE b.Country=$1 ";
			$stmtmanager = pg_prepare($dbconn,"ps2",$sqlmanager);
			$resultManager = pg_execute($dbconn,"ps2",array($vcountry));
			$resultArr1 = pg_fetch_all($resultManager);

			foreach($resultArr1 as $array1)
			{
			     '<tr>
							<td>'. $propManagerID=$array1['manager_ssn'].'</td>	
			          </tr>';
			}
		$propManagerID=(int)$propManagerID;
		if (isset( $_POST['save'] ))
		{
			$rented  = $_POST['iRented'];
			$address = $_POST['iAddress'];
			$city = $_POST['icity'];
			$province_State = $_POST['iProvince_State'];
			$propertyType = $_POST['iPropertyType'];
			$accommodates = $_POST['iAccommodates'];
			$amenities = $_POST['iAmenities'];
			$bedroom = $_POST['iBedroom'];
			$beds = $_POST['iBeds'];
			$bathroom = $_POST['iBathroom'];
			$hostID = $_POST['iHostID'];


			
			
			$query = "INSERT INTO project.Property(PropertyID,Rented,Address,City,Province_State,Country,PropertyType,Accommodates,Amenities,Bedroom,Beds,Bathroom,HostID ,PropManagerID,BranchNumber ) VALUES ('$propertyid','$rented','$address','$city','$province_State','$vcountry','$propertyType','$accommodates','$amenities','$bedroom','$beds','$bathroom','$hostID','$propManagerID','$branchnumber')";
			$result = pg_query($dbconn,$query);

			if(!$result){
				die("Error in SQL query:" .pg_last_error());
			}
			echo "  Property Successfully Entered. Would you like to enter another Property ". "<a href='host1.php'>Post Again</a>";

			pg_free_result($result);
			pg_close($dbconn);

		}
	?>
<body>
	<div id="header"> Host Property Posting </div>
	<form id="testform" name="testform" method="POST" action="">
		
		<p> <label for="iRented"> Currently Rented:</label>
				<select name="iRented">
						<option value="1">Yes</option>
						<option value="0">No</option>
					

				</select>
		</p>

		<p> <label for="iAddress">Address:</label>
				<input name="iAddress" type="text" id="iAddress"/>
		</p>

		<p> <label for="icity">City:</label>
				<input name="icity" type="text" id="icity"/>
		</p>
		
		
		<p> <label for="iProvince_State">Province_State:</label>
				<input name="iProvince_State" type="text" id="iProvince_State"/>
		</p>


		<p> <label for="iPropertyType">Property Type:</label>
				<select name="iPropertyType">
						<option value="Apartment">Apartment</option>
						<option value="BedandBreakfast">Bed and Breakfast</option>
						<option value="UniqueHome">Unique Home</option>
						<option value="VacationHome">Vacation Home</option>
						<option value="Cottage">Cottage</option>

				</select>
		</p>

		<p> <label for="iAccommodates">Accommodates:</label>
				<input name="iAccommodates" type="number" id="iAccommodates"/>
		</p>
		
		<p> <label for="iAmenities">Amenities:</label>
				<input name="iAmenities" type="text" id="iAmenities"/>
		</p>

		<p> <label for="iBedroom">Bedroom:</label>
				<input name="iBedroom" type="number" id="iBedroom"/>
		</p>

		<p> <label for="iBeds">Beds:</label>
				<input name="iBeds" type="number" id="iBeds"/>
		</p>
		
		
		<p> <label for="iBathroom">Bathrooms:</label>
				<input name="iBathroom" type="number" id="iBathroom"/>
		</p>
		<p> <label for="iHostID">HostID:</label>
				<input name="iHostID" type="number" id="iHostID"/>
		</p>

		
		<p><input type="submit" value="Post" name="save" /></p>
	</form>

</html>
