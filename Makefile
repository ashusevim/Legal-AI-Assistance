.PHONY: setup backend frontend test docker-up docker-down clean

# === Full Setup ===
setup: setup-backend setup-frontend

setup-backend:
    cd backend && mvn clean install -DskipTests

setup-frontend:
    cd frontend && npm install

# === Run Services ===
backend:
    cd backend && mvn spring-boot:run -Dspring-boot.run.profiles=dev

frontend:
    cd frontend && ng serve --proxy-config proxy.conf.json

# === ChromaDB ===
chromadb:
    docker run -d --name chromadb -p 8001:8000 -v ./data/chromadb:/chroma/chroma chromadb/chroma:latest

# === Testing ===
test: test-backend test-frontend

test-backend:
    cd backend && mvn test

test-frontend:
    cd frontend && ng test --watch=false --browsers=ChromeHeadless

# === Docker ===
docker-up:
    docker-compose up --build -d

docker-down:
    docker-compose down

# === Cleanup ===
clean:
    cd backend && mvn clean
    rm -rf frontend/node_modules frontend/dist frontend/.angular data/chromadb