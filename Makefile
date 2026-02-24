.PHONY: setup backend frontend ingest test docker-up docker-down clean

# Full setup
setup: setup-backend setup-frontend

setup-backend:
    cd backend && python3 -m venv venv && . venv/bin/activate && pip install -r requirements.txt

setup-frontend:
    cd frontend && npm install

# Run services
backend:
    cd backend && . venv/bin/activate && uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

frontend:
    cd frontend && npm run dev

# Data
ingest:
    cd backend && . venv/bin/activate && python ../scripts/ingest.py --input-dir ../data/raw

# Testing
test: test-backend test-frontend

test-backend:
    cd backend && . venv/bin/activate && pytest tests/ -v --cov=app

test-frontend:
    cd frontend && npm run test

# Docker
docker-up:
    docker-compose up --build -d

docker-down:
    docker-compose down

# Cleanup
clean:
    rm -rf backend/venv frontend/node_modules data/chromadb __pycache__