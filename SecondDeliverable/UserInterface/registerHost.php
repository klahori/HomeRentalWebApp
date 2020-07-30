<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" href="css/style1.css"/>
<title>Host Registration</title>
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
			$sql ="SELECT s.HostID from project.Host s ";
			$stmt = pg_prepare($dbconn,"ps",$sql);
			$resultHost = pg_execute($dbconn,"ps",array());
			$resultArr = pg_fetch_all($resultHost);

			foreach($resultArr as $array)
			{
			     '<tr>
							<td>'. $hostid=$array['hostid'].'</td>	
			          </tr>';
			}
			$hostid=(int)$hostid+1;
			echo 'Your Host ID number is ' ,$hostid, ' do write this down as you will always need it'; 
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
		if (isset( $_POST['save'] ))
		{
			$password= $_POST['ipassword'];
			$lastname = $_POST['ilastname'];
			$firstname = $_POST['ifirstname'];
			$middlename = $_POST['imiddlename'];
			$city = $_POST['icity'];
			$address = $_POST['iaddress'];
			$province_state  = $_POST['iprovince_state'];
			
			

			
			
			$query = "INSERT INTO project.Host(HostID,HashedPassword ,FName,MName,LName,Address,City,Province_State ,Country ,BranchNumber  ) VALUES ('$hostid','$password','$firstname','$middlename','$lastname','$address','$city','$province_state','$vcountry','$branchnumber' )";
			$result = pg_query($dbconn,$query);

			if(!$result){
				die("Error in SQL query:" .pg_last_error());
			}

			echo "  Data Successfully Entered ". "<a href='pickLogin.php'>login now</a>";

			pg_free_result($result);
			pg_close($dbconn);

		}
	?>
<body>
	<div id="header"> Host REGISTRATION FORM</div>
	<form id="testform" name="testform" method="POST" action="">
		
		<p> <label for="ifirstname">First name:</label>
				<input name="ifirstname" type="text" id="ifirstname"/>
		</p>
		
		<p> <label for="imiddlename">Middle name:</label>
				<input name="ilastname" type="text" id="imiddlename"/>
		</p>
		
		<p> <label for="ilastname">Last name:</label>
				<input name="imiddlename" type="text" id="ilastname"/>
		</p>
		<p> <label for="ipassword">password:</label>
				<input name="ipassword" type="password" id="ipassword"/>
		</p>

		<p> <label for="iaddress">Address:</label>
				<input name="iaddress" type="text" id="iaddress"/>
		</p>

		<p> <label for="icity">City:</label>
				<input name="icity" type="text" id="icity"/>
		</p>
		
		<p> <label for="iprovince_state">Province/State:</label>
				<input name="iprovince_state" type="text" id="iprovince_state"/>
		</p>
		
		

		<p><input type="submit" value="Register" name="save" /></p>
	</form>

</body>
</html>
