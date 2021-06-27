FROM builder
RUN apt-get update && apt-get install -y python3-pip && pip3 install --upgrade pip && pip3 install rq==1.8.1
COPY builder_queue.py builder_queue_lib.py builder_queue_entrypoint.sh ./
ENTRYPOINT ["./builder_queue_entrypoint.sh"]
