# FROM python:3.11-slim

# WORKDIR /app

# COPY app/requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt

# COPY app/ .

# EXPOSE 8000

# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]


FROM python:3.10

WORKDIR /app

# install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# copy code
COPY . .

# environment variables (optional defaults)
ENV PYTHONUNBUFFERED=1

# expose FastAPI port
EXPOSE 8000

# run BOTH API + worker using shell
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port 8000 & python worker.py"]