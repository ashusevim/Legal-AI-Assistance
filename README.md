# ⚖️ Legal AI Assistance Chatbot

An AI-powered chatbot that provides legal information and guidance using Retrieval-Augmented Generation (RAG). Built with Spring Boot, LangChain4j, ChromaDB, and Angular.

> ⚠️ **Disclaimer**: This tool provides legal *information*, not legal *advice*. Users should always consult a qualified attorney for legal decisions.

---

## 📋 Table of Contents

- [Team Structure](#team-structure)
- [Architecture Overview](#architecture-overview)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
- [Development Workflow](#development-workflow)
- [API Endpoints](#api-endpoints)
- [Data Ingestion](#data-ingestion)
- [Testing](#testing)
- [Deployment](#deployment)
- [Contributing Guidelines](#contributing-guidelines)
- [Roadmap](#roadmap)

---

## 👥 Team Structure

| Role | Responsibilities |
|------|-----------------|
| **Person 1 — Backend & RAG Pipeline** | Spring Boot server, RAG pipeline with LangChain4j, LLM integration, document chunking & embedding |
| **Person 2 — Frontend & UX** | Angular chat interface, conversation management, responsive design, disclaimer UI, Angular Material |
| **Person 3 — Data & DevOps** | Legal data collection/processing, ingestion service, Docker setup, testing, CI/CD |

### Communication
- Use **GitHub Issues** for task tracking
- Use **feature branches** and **pull requests** for all changes
- Daily async standups (post what you did, what you'll do, blockers)

---

## 🏗️ Architecture Overview

```
┌──────────────────┐       ┌──────────────────────────────────────────────┐
│  Angular Frontend │──────▶│  Spring Boot Backend                         │
│  (Port 4200)      │◀──────│  (Port 8080)                                 │
└──────────────────┘       │                                              │
                           │  ┌────────────────┐  ┌────────────────────┐  │
                           │  │ ChatController  │─▶│  RAGService        │  │
                           │  └────────────────┘  │                    │  │
                           │                      │  1. Embed query    │  │
                           │                      │  2. Search ChromaDB│  │
                           │                      │  3. Build prompt   │  │
                           │                      │  4. Call LLM       │  │
                           │                      │  5. Return+sources │  │
                           │                      └────────┬───────────┘  │
                           │                               │              │
                           │                     ┌─────────▼───────────┐  │
                           │                     │ ChromaDB (Vectors)  │  │
                           │                     └─────────────────────┘  │
                           └──────────────────────────────────────────────┘

Legal Documents ──▶ Ingestion Service ──▶ Chunks ──▶ Embeddings ──▶ ChromaDB
```

---

## 🛠️ Tech Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| Backend | Java 21, Spring Boot 3.3+ | REST API server |
| LLM Orchestration | LangChain4j | RAG pipeline, prompt management |
| Vector Database | ChromaDB | Store and search document embeddings |
| Embeddings | OpenAI `text-embedding-3-small` or HuggingFace | Convert text to vectors |
| LLM | OpenAI GPT-4o / Anthropic Claude | Generate responses |
| Frontend | Angular 18+, TypeScript | Chat interface |
| Styling | Angular Material + Tailwind CSS | UI components & styling |
| Database | H2 (dev) / PostgreSQL (prod) | Conversation history |
| Build Tool | Maven | Backend build & dependency management |
| Containerization | Docker + Docker Compose | Consistent environments |
| Testing | JUnit 5, Mockito, Jasmine/Karma | Unit & integration tests |

---

## 📁 Project Structure

```
Legal-AI-Assistance/
├── backend/
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/legalai/
│   │   │   │   ├── LegalAiApplication.java         # Spring Boot entry point
│   │   │   │   ├── config/
│   │   │   │   │   ├── LlmConfig.java              # LLM provider beans
│   │   │   │   │   ├── ChromaConfig.java            # ChromaDB connection
│   │   │   │   │   └── CorsConfig.java              # CORS for Angular dev
│   │   │   │   ├── controller/
│   │   │   │   │   ├── ChatController.java          # Chat REST endpoints
│   │   │   │   │   └── DocumentController.java      # Document management endpoints
│   │   │   │   ├── service/
│   │   │   │   │   ├── LlmService.java              # LLM provider integration
│   │   │   │   │   ├── RagService.java              # RAG pipeline logic
│   │   │   │   │   ├── IngestionService.java        # Document ingestion
│   │   │   │   │   └── ConversationService.java     # Conversation history
│   │   │   │   ├── model/
│   │   │   │   │   ├── dto/
│   │   │   │   │   │   ├── ChatRequest.java         # Request DTO
│   │   │   │   │   │   └── ChatResponse.java        # Response DTO
│   │   │   │   │   └── entity/
│   │   │   │   │       ├── Conversation.java        # JPA entity
│   │   │   │   │       └── Message.java             # JPA entity
│   │   │   │   └── repository/
│   │   │   │       ├── ConversationRepository.java
│   │   │   │       └── MessageRepository.java
│   │   │   └── resources/
│   │   │       ├── application.yml                  # Main config
│   │   │       ├── application-dev.yml              # Dev profile
│   │   │       └── prompts/
│   │   │           └── legal-system-prompt.txt      # System prompt template
│   │   └── test/
│   │       └── java/com/legalai/
│   │           ├── controller/
│   │           │   └── ChatControllerTest.java
│   │           └── service/
│   │               ├── RagServiceTest.java
│   │               └── LlmServiceTest.java
│   ├── pom.xml
│   └── Dockerfile
├── frontend/
│   ├── src/
│   │   ├── app/
│   │   │   ├── app.component.ts
│   │   │   ├── app.config.ts
│   │   │   ├── app.routes.ts
│   │   │   ├── components/
│   │   │   │   ├── chat-window/
│   │   │   │   │   ├── chat-window.component.ts
│   │   │   │   │   ├── chat-window.component.html
│   │   │   │   │   ├── chat-window.component.scss
│   │   │   │   │   └── chat-window.component.spec.ts
│   │   │   │   ├── message-bubble/
│   │   │   │   │   ├── message-bubble.component.ts
│   │   │   │   │   ├── message-bubble.component.html
│   │   │   │   │   └── message-bubble.component.scss
│   │   │   │   ├── source-card/
│   │   │   │   │   ├── source-card.component.ts
│   │   │   │   │   ├── source-card.component.html
│   │   │   │   │   └── source-card.component.scss
│   │   │   │   └── disclaimer/
│   │   │   │       ├── disclaimer.component.ts
│   │   │   │       └── disclaimer.component.html
│   │   │   ├── services/
│   │   │   │   ├── chat.service.ts
│   │   │   │   └── document.service.ts
│   │   │   ├── models/
│   │   │   │   ├── chat-request.model.ts
│   │   │   │   └── chat-response.model.ts
│   │   │   └── environments/
│   │   │       ├── environment.ts
│   │   │       └── environment.prod.ts
│   │   ├── assets/
│   │   ├── styles.scss
│   │   ├── index.html
│   │   └── main.ts
│   ├── angular.json
│   ├── package.json
│   ├── tsconfig.json
│   └── Dockerfile
├── data/
│   ├── raw/                            # Original legal documents (PDF, TXT, etc.)
│   ├── processed/                      # Cleaned and chunked documents
│   └── sources.json                    # Metadata about data sources
├── scripts/
│   ├── seed-data.sh                    # Download sample legal data
│   └── evaluate.py                     # Response quality evaluation
├── docker-compose.yml
├── .env.example
├── .gitignore
├── Makefile
└── README.md
```

---

## ✅ Prerequisites

Ensure every team member has the following installed:

- **Java 21** — `java --version`
- **Maven 3.9+** — `mvn --version`
- **Node.js 20+** — `node --version`
- **npm 10+** — `npm --version`
- **Angular CLI 18+** — `ng version` (install: `npm install -g @angular/cli`)
- **Docker & Docker Compose** — `docker --version`
- **Git** — `git --version`
- **An LLM API key** (OpenAI or Anthropic)

---

## 🚀 Setup Instructions

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd Legal-AI-Assistance
```

### 2. Environment Variables

```bash
cp .env.example .env
```

Edit `.env` with your API keys (these get mapped to `application.yml` or Docker env):

```env
# LLM Configuration
OPENAI_API_KEY=sk-your-openai-key-here
# OR
ANTHROPIC_API_KEY=sk-ant-your-anthropic-key-here

LLM_PROVIDER=openai
LLM_MODEL=gpt-4o
EMBEDDING_MODEL=text-embedding-3-small

# Database
SPRING_DATASOURCE_URL=jdbc:h2:file:./data/legalai-db
SPRING_DATASOURCE_USERNAME=sa
SPRING_DATASOURCE_PASSWORD=

# ChromaDB
CHROMA_HOST=localhost
CHROMA_PORT=8001
```

### 3. Backend Setup (Person 1)

```bash
cd backend

# Build the project
mvn clean install -DskipTests

# Run with dev profile
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

Backend will be available at: `http://localhost:8080`
Swagger UI at: `http://localhost:8080/swagger-ui.html`

### 4. Frontend Setup (Person 2)

```bash
cd frontend

# Install dependencies
npm install

# Start Angular dev server with proxy to backend
ng serve --proxy-config proxy.conf.json
```

Frontend will be available at: `http://localhost:4200`

### 5. ChromaDB Setup (Person 3)

```bash
# Start ChromaDB using Docker
docker run -d --name chromadb \
  -p 8001:8000 \
  -v ./data/chromadb:/chroma/chroma \
  chromadb/chroma:latest
```

### 6. Data Ingestion (Person 3)

```bash
# Place legal documents in data/raw/
# Then trigger ingestion via API
curl -X POST http://localhost:8080/api/documents/ingest \
  -H "Content-Type: application/json" \
  -d '{"sourceDirectory": "data/raw"}'
```

### 7. Run Everything with Docker (Recommended)

```bash
docker-compose up --build
```

This starts:
- Backend on `http://localhost:8080`
- Frontend on `http://localhost:4200`
- ChromaDB on `http://localhost:8001`
- PostgreSQL on `http://localhost:5432`

---

## 💻 Development Workflow

### Git Branching Strategy

```
main              ← Production-ready code
├── develop       ← Integration branch
│   ├── feat/backend-rag-pipeline      (Person 1)
│   ├── feat/frontend-chat-ui          (Person 2)
│   └── feat/data-ingestion-pipeline   (Person 3)
```

### Workflow Steps

```bash
# 1. Create a feature branch from develop
git checkout develop
git pull origin develop
git checkout -b feat/your-feature-name

# 2. Make changes, commit often
git add .
git commit -m "feat: add RAG retrieval service"

# 3. Push and create a Pull Request
git push origin feat/your-feature-name
# Open PR on GitHub: feat/your-feature-name → develop

# 4. Get at least 1 review from a teammate before merging
```

### Commit Message Convention

```
feat:     New feature
fix:      Bug fix
docs:     Documentation changes
refactor: Code refactoring
test:     Adding tests
chore:    Maintenance tasks
```

### Angular Proxy Config (for dev)

Create this file so the Angular dev server proxies API calls to Spring Boot:

```json
// frontend/proxy.conf.json
{
  "/api": {
    "target": "http://localhost:8080",
    "secure": false,
    "changeOrigin": true
  }
}
```

---

## 📡 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/chat` | Send a message and get a response |
| `GET`  | `/api/chat/{conversationId}/history` | Get conversation history |
| `POST` | `/api/documents/upload` | Upload a legal document |
| `POST` | `/api/documents/ingest` | Trigger ingestion of documents |
| `GET`  | `/api/documents` | List all ingested documents |
| `GET`  | `/actuator/health` | Health check (Spring Actuator) |

### Example: Chat Request

```bash
curl -X POST http://localhost:8080/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "message": "What are my rights as a tenant if my landlord refuses repairs?",
    "conversationId": "conv_123"
  }'
```

### Example: Chat Response

```json
{
  "reply": "As a tenant, you generally have the right to a habitable living space...",
  "sources": [
    {
      "document": "Tenant Rights Act - Section 42",
      "relevanceScore": 0.92
    }
  ],
  "conversationId": "conv_123",
  "disclaimer": "This is legal information, not legal advice. Consult an attorney for your specific situation."
}
```

---

## 📥 Data Ingestion

### Supported Document Types
- PDF (`.pdf`)
- Plain Text (`.txt`)
- Markdown (`.md`)
- Word Documents (`.docx`)

### Suggested Legal Data Sources
- [Cornell LII](https://www.law.cornell.edu/) — US Code & Supreme Court opinions
- [EUR-Lex](https://eur-lex.europa.eu/) — EU legislation
- [FreeLaw Project](https://free.law/) — US case law
- Government legal aid websites
- Public domain legal FAQs

### Ingestion via REST API

```bash
# Upload a single document
curl -X POST http://localhost:8080/api/documents/upload \
  -F "file=@data/raw/tenant_rights.pdf" \
  -F "category=tenant-law"

# Ingest a full directory
curl -X POST http://localhost:8080/api/documents/ingest \
  -H "Content-Type: application/json" \
  -d '{"sourceDirectory": "data/raw"}'

# Check ingestion status
curl http://localhost:8080/api/documents/status
```

---

## 🧪 Testing

### Backend Tests (JUnit 5 + Mockito)

```bash
cd backend
mvn test                         # Run all tests
mvn test -Dtest=ChatControllerTest   # Run specific test class
mvn verify                       # Run integration tests
```

### Frontend Tests (Jasmine + Karma)

```bash
cd frontend
ng test                          # Run unit tests with Karma
ng test --code-coverage          # With coverage report
ng e2e                           # End-to-end tests (if configured)
```

### Run All Tests

```bash
make test
```

---

## 🐳 Deployment

### Docker Compose (Staging/Production)

```bash
# Build and start all services
docker-compose up -d --build

# View logs
docker-compose logs -f backend
docker-compose logs -f frontend

# Stop services
docker-compose down
```

### Environment Checklist for Production

- [ ] Set strong API keys in `.env`
- [ ] Enable HTTPS (reverse proxy with Nginx/Traefik)
- [ ] Set `spring.profiles.active=prod`
- [ ] Configure CORS for your domain only
- [ ] Set up rate limiting (Spring Boot filter or API gateway)
- [ ] Switch to PostgreSQL from H2
- [ ] Enable logging and monitoring (Spring Actuator + Prometheus)
- [ ] Add legal disclaimer to all responses
- [ ] Review data privacy compliance (GDPR, etc.)
- [ ] Angular production build with `ng build --configuration production`

---

## 🤝 Contributing Guidelines

1. **Never push directly to `main` or `develop`**
2. **Every PR needs at least 1 approval**
3. **Write tests for new features**
4. **Update this README if you change setup steps**
5. **Keep `.env` out of git** (it's in `.gitignore`)
6. **Follow Java naming conventions** and **Angular style guide**
7. **Use Javadoc** for public service methods
8. **Use TypeScript strict mode** in frontend

---

## 🗺️ Roadmap

### Phase 1 — MVP (Weeks 1–3)
- [x] Project setup & README
- [ ] Spring Boot backend with chat endpoint
- [ ] LangChain4j RAG pipeline with ChromaDB
- [ ] Document ingestion service
- [ ] Angular chat UI with Angular Material
- [ ] Legal disclaimer on all responses

### Phase 2 — Core Features (Weeks 4–6)
- [ ] Conversation history & context (JPA + PostgreSQL)
- [ ] Source citation display in Angular UI
- [ ] Multi-document type ingestion (PDF, DOCX)
- [ ] Prompt engineering for legal accuracy
- [ ] JUnit + Angular test suites

### Phase 3 — Polish & Deploy (Weeks 7–8)
- [ ] Docker Compose deployment
- [ ] Response quality evaluation
- [ ] Rate limiting & global exception handling
- [ ] UI/UX improvements (loading states, error handling)
- [ ] CI/CD pipeline (GitHub Actions)

### Phase 4 — Stretch Goals
- [ ] Multi-language support
- [ ] WebSocket for streaming responses
- [ ] Document drafting assistance
- [ ] User authentication (Spring Security + JWT)
- [ ] Analytics dashboard

---

## 📄 License

This project is for educational purposes. See [LICENSE](LICENSE) for details.

---

## 📞 Support

If you run into issues:
1. Check the [Troubleshooting](#) section
2. Open a GitHub Issue
3. Tag the relevant team member