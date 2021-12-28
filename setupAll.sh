#!/bin/bash

mail -s "TrainTicket instance is setting up!" $(geni-get slice_email)

source /local/repository/aptSetup.sh
source /local/repository/shcSetup.sh
source /local/repository/dockerSetup.sh

mail -s "TrainTicket instance finished setting up!" $(geni-get slice_email)
