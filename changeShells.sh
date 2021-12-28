#!/bin/bash

echo $(ls /users) > /tmp/changeShells.txt

for user in $(ls /users)
do
	sudo chsh $user --shell /bin/bash
done

