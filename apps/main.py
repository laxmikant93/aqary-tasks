from fastapi import FastAPI
from pydantic import BaseModel
from typing import List
import uuid

app = FastAPI()

# In-memory "database"
tasks = []

class Task(BaseModel):
    title: str
    description: str | None = None


@app.get("/health")
def health():
    return {"status": "ok"}


@app.post("/tasks")
def create_task(task: Task):
    new_task = {
        "id": str(uuid.uuid4()),
        "title": task.title,
        "description": task.description
    }
    tasks.append(new_task)
    return new_task