#!/bin/bash

START_FILE=/local/checkpoints/train-ticket/docker-started
DOCKER_QUICKSTART_FILE=/local/train-ticket/deployment/docker-compose-manifests/quickstart-docker-compose.yml
DOCKER_QUICKSTART_JAEGER_FILE=/local/train-ticket/deployment/docker-compose-manifests/docker-compose-with-jaeger.yml

STARTED=0
if [[ -f START_FILE ]]; then
	STARTED=1
fi

START_FLAG=0
STOP_FLAG=0
JAEGER_FLAG=0

for arg in $@
do
	case flag in
		'-S' | '--start')
			# if [[ $STARTED == 1 ]]; then
			# 	echo "TrainTicket has already been started!"
			# fi
			START_FLAG=1
		;;

		'-Q' | '--quit' | '--stop')
			# if [[ $STARTED == 0 ]]; then
			# 	echo "TrainTicket is not running!"
			# fi
			STOP_FLAG=1
		;;

		'-J' | '--jaeger')
			JAEGER_FLAG=1
		;;

		*)
			echo "Unsupported commands!"
			exit 1
	esac
done

if [[ $START_FLAG == 1 ]]; then
	if [[ $STOP_FLAG == 1 ]]; then
		echo "Cannot set both start and stop flags!"
		exit 3
	fi

	if [[ $STARTED == 1 ]]; then
		echo "TrainTicket has already been started!"
		exit 4
	fi

	if [[ $JAEGER_FLAG == 0 ]]; then
		sudo docker-compose -f $DOCKER_QUICKSTART_FILE -p train-ticket-plain up --detach
	else
		sudo docker-compose -f $DOCKER_QUICKSTART_JAEGER_FILE -p train-ticket-jaeger up --detach
	fi
	sudo touch START_FILE
elif [[ $STOP_FLAG == 1 ]]; then
	if [[ $START_FLAG == 1 ]]; then
		echo "Cannot set both start and stop flags!"
		exit 3
	fi

	if [[ $STARTED == 0 ]]; then
		echo "TrainTicket is not currently running!"
		exit 5
	fi

	if [[ $JAEGER_FLAG == 0 ]]; then
		sudo docker container kill $(sudo docker container ps --filter "name=train-ticket-plain" -q)
	else
		sudo docker container kill $(sudo docker container ps --filter "name=train-ticket-jaeger" -q)
	fi
	sudo rm -rf START_FILE
else
	echo "Must set either [[ -S / --start ]] or [[ -Q / --quit / --stop ]] flag!"
	exit 2
fi

####################



















