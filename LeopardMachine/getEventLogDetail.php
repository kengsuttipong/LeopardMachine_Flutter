<?php
header("content-type:text/javascript;charset=utf-8");
error_reporting(0);
error_reporting(E_ERROR | E_PARSE);
$link = mysqli_connect('localhost', 'root', 'Keng1357910', "LeopardMachine");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}

if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {	

		$EventLogID = $_GET['EventLogID'];

		$result = mysqli_query($link, "SELECT `EventLogID`, `MachineID`, `ActionDate`, `ActionType`, `Comment`, `ImageUrl`, concat(tbuser.FirstName, ' ', tbuser.LastName) as 'UserFirstLasrName', `MachineCode`, `MachineName`,`MaintenanceDate`, `CauseDetail`, `CauseImageUrl`, `FixedDetail`, `FixedImageUrl`, `IssueDetail`, `IssueImageUrl`, `SolveListDetail`, `SolveListImageUrl`
									   FROM `tbeventlog`
									   left join tbuser on tbuser.userid = tbeventlog.UserID
									   where EventLogID = '$EventLogID'");

		if ($result) {

			while($row=mysqli_fetch_assoc($result)){
			$output[]=$row;

			}	// while

			echo json_encode($output);

		} //if

	} else echo "Welcome LeopardMachine";	// if2
   
}	// if1


	mysqli_close($link);
?>