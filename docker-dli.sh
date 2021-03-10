case "$1" in
	start)
		sudo docker run --runtime nvidia -it --rm --network host \
		    --volume ~/nvdli-data:/nvdli-nano/data \
		    --volume /tmp/argus_socket:/tmp/argus_socket \
		    --device /dev/video0 \
		    nvcr.io/nvidia/dli/dli-nano-ai:v2.0.1-r32.4.4
	;;
	stop)
		CONTAINERID=`sudo docker ps | grep -v CON | awk ' { print $1 } '`
		docker stop $CONTAINERID
	;;
	status)
		CONTAINERID=`sudo docker ps | grep -v CON | awk ' { print $1 } '`
		if [ -z $CONTAINER ]
		then
			echo "Not running"
		else
			echo "Container Running : $CONTAINERID "
		fi
	;;
	*)
		echo "USAGE: $0 (stop|start|status)"
	;;
esac


