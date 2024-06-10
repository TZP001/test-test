<?php

header("Content-Type: application/force-download");
header("Content-Disposition: attachement; filename=$filename");
readfile("files/builder_unix.sh");

?>
