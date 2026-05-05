import boto3
import json
import time
import psycopg2
import os

QUEUE_URL = os.getenv("https://sqs.us-east-1.amazonaws.com/111111111111/fastapi-jobs")

conn = psycopg2.connect(
    host=os.getenv("localhost:5432"),
    user=os.getenv("postgres"),
    password=os.getenv("Password123@"),
    dbname=os.getenv("mydb")
)

cursor = conn.cursor()
sqs = boto3.client("sqs", region_name="us-east-1")

def worker_loop():
    while True:
        messages = sqs.receive_message(
            QueueUrl=QUEUE_URL,
            MaxNumberOfMessages=5,
            WaitTimeSeconds=10
        ).get("Messages", [])

        for msg in messages:
            body = json.loads(msg["Body"])

            cursor.execute(
                "INSERT INTO tasks(data) VALUES (%s)",
                (json.dumps(body),)
            )
            conn.commit()

            sqs.delete_message(
                QueueUrl=QUEUE_URL,
                ReceiptHandle=msg["ReceiptHandle"]
            )

        time.sleep(2)