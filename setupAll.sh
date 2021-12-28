#!/bin/bash

mail -s "TrainTicket instance is setting up!" $(geni-get slice_email)

source changeShells.sh
source aptSetup.sh
source shcSetup.sh
source dockerSetup.sh

mail -s "TrainTicket instance finished setting up!" $(geni-get slice_email)
