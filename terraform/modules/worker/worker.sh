# #!/bin/bash

# yum update -y
# yum install -y python3 git

# pip3 install boto3 psycopg2-binary

# cat <<EOF > /app/worker.py
# import boto3, json, time, psycopg2

# sqs = boto3.client("sqs")

# QUEUE_URL = "${QUEUE_URL}"

# DB_CONN = psycopg2.connect(
#     host="${DB_HOST}",
#     user="${DB_USER}",
#     password="${DB_PASS}",
#     dbname="${DB_NAME}"
# )

# cursor = DB_CONN.cursor()

# while True:
#     msgs = sqs.receive_message(
#         QueueUrl=QUEUE_URL,
#         MaxNumberOfMessages=1,
#         WaitTimeSeconds=10
#     )

#     if "Messages" in msgs:
#         for m in msgs["Messages"]:
#             body = json.loads(m["Body"])

#             cursor.execute(
#                 "INSERT INTO tasks(data) VALUES (%s)",
#                 (json.dumps(body),)
#             )
#             DB_CONN.commit()

#             sqs.delete_message(
#                 QueueUrl=QUEUE_URL,
#                 ReceiptHandle=m["ReceiptHandle"]
#             )

#     time.sleep(2)
# EOF

# python3 /app/worker.py