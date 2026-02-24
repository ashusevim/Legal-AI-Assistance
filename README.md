# ⚖️ Legal AI Assistance Chatbot

An AI-powered chatbot that provides legal information and guidance using Retrieval-Augmented Generation (RAG). Built with FastAPI, LangChain, ChromaDB, and React.

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
| **Person 1 — Backend & RAG Pipeline** | FastAPI server, RAG pipeline, LLM integration, document chunking & embedding |
| **Person 2 — Frontend & UX** | React chat interface, conversation management, responsive design, disclaimer UI |
| **Person 3 — Data & DevOps** | Legal data collection/processing, ingestion scripts, Docker setup, testing, CI/CD |

### Communication
- Use **GitHub Issues** for task tracking
- Use **feature branches** and **pull requests** for all changes
- Daily async standups (post what you did, what you'll do, blockers)

---

## 🏗️ Architecture Overview

```
┌─────────────┐     ┌──────────────────────────────────────────────┐
│   React UI  │────▶│  FastAPI Backend                             │
│  (Frontend) │◀────│                                              │
└─────────────┘     │  ┌─────────────┐    ┌─────────────────────┐  │
                    │  │ Chat Router  │───▶│   RAG Service        │  │
                    │  └─────────────┘    │                     │  │
                    │                     │  1. Embed query      │  │
                    │                     │  2. Search ChromaDB  │  │
                    │                     │  3. Build prompt     │  │
                    │                     │  4. Call LLM         │  │
                    │                     │  5. Return + sources │  │
                    │                     └──────────┬──────────┘  │
                    │                                │              │
                    │                     ┌──────────▼──────────┐  │
                    │                     │  ChromaDB (Vectors)  │  │
                    │                     └─────────────────────┘  │
                    └──────────────────────────────────────────────┘

Legal Documents ──▶ Ingestion Script ──▶ Chunks ──▶ Embeddings ──▶ ChromaDB
```

---

## 🛠️ Tech Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| Backend | Python 3.11+, FastAPI | REST API server |
| LLM Orchestration | LangChain | RAG pipeline, prompt management |
| Vector Database | ChromaDB | Store and search document embeddings |
| Embeddings | OpenAI `text-embedding-3-small` or HuggingFace | Convert text to vectors |
| LLM | OpenAI GPT-4o / Anthropic Claude | Generate responses |
| Frontend | React 18 + TypeScript | Chat interface |
| Styling | Tailwind CSS | UI styling |
| Database | SQLite (dev) / PostgreSQL (prod) | Conversation history |
| Containerization | Docker + Docker Compose | Consistent environments |
| Testing | pytest, React Testing Library | Unit & integration tests |

---

## 📁 Project Structure

```
Legal-AI-Assistance/
├── backend/
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py                 # FastAPI entry point
│   │   ├── config.py               # Environment config
│   │   ├── routes/
│   │   │   ├── __init__.py
│   │   │   ├── chat.py             # Chat endpoints
│   │   │   └── documents.py        # Document management endpoints
│   │   ├── services/
│   │   │   ├── __init__.py
│   │   │   ├── llm_service.py      # LLM provider integration
│   │   │   ├── rag_service.py      # RAG pipeline logic
│   │   │   └── history_service.py  # Conversation history
│   │   ├── models/
│   │   │   ├── __init__.py
│   │   │   └── schemas.py          # Pydantic request/response models
│   │   └── prompts/
│   │       └── legal_prompt.py     # System prompts & templates
│   ├── requirements.txt
│   └── Dockerfile
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── ChatWindow.tsx      # Main chat component
│   │   │   ├── MessageBubble.tsx   # Individual message display
│   │   │   ├── SourceCard.tsx      # Legal source citations
│   │   │   └── Disclaimer.tsx      # Legal disclaimer banner
│   │   ├── services/
│   │   │   └── api.ts              # Backend API client
│   │   ├── App.tsx
│   │   └── main.tsx
│   ├── package.json
│   └── Dockerfile
├── data/
│   ├── raw/                        # Original legal documents (PDF, TXT, etc.)
│   ├── processed/                  # Cleaned and chunked documents
│   └── sources.json                # Metadata about data sources
├── scripts/
│   ├── ingest.py                   # Document ingestion pipeline
│   ├── evaluate.py                 # Response quality evaluation
│   └── seed_data.py                # Download sample legal data
├── tests/
│   ├── backend/
│   │   ├── test_chat.py
│   │   ├── test_rag_service.py
│   │   └── test_llm_service.py
│   └── frontend/
│       └── ChatWindow.test.tsx
├── docker-compose.yml
├── .env.example
├── .gitignore
├── Makefile
└── README.md
```

---

## ✅ Prerequisites

Ensure every team member has the following installed:

- **Python 3.11+** — `python3 --version`
- **Node.js 18+** — `node --version`
- **npm 9+** — `npm --version`
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

Edit `.env` with your API keys:

```env
# LLM Configuration
OPENAI_API_KEY=sk-your-openai-key-here
# OR
ANTHROPIC_API_KEY=sk-ant-your-anthropic-key-here

# App Configuration
LLM_PROVIDER=openai          # openai or anthropic
LLM_MODEL=gpt-4o             # or claude-sonnet-4-20250514
EMBEDDING_MODEL=text-embedding-3-small

# Backend
BACKEND_HOST=0.0.0.0
BACKEND_PORT=8000
CHROMA_PERSIST_DIR=./data/chromadb

# Frontend
VITE_API_URL=http://localhost:8000
```

### 3. Backend Setup (Person 1)

```bash
# Create virtual environment
cd backend
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run the server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Backend will be available at: `http://localhost:8000`
API docs at: `http://localhost:8000/docs`

### 4. Frontend Setup (Person 2)

```bash
cd frontend

# Install dependencies
npm install

# Start dev server
npm run dev
```

Frontend will be available at: `http://localhost:5173`

### 5. Data Ingestion (Person 3)

```bash
# Activate backend venv
source backend/venv/bin/activate

# Place legal documents in data/raw/
# Then run ingestion
python scripts/ingest.py --input-dir data/raw --output-dir data/processed
```

### 6. Run Everything with Docker (Recommended)

```bash
docker-compose up --build
```

This starts:
- Backend on `http://localhost:8000`
- Frontend on `http://localhost:3000`
- ChromaDB on `http://localhost:8001`

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

---

## 📡 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/chat` | Send a message and get a response |
| `GET`  | `/api/chat/{conversation_id}/history` | Get conversation history |
| `POST` | `/api/documents/upload` | Upload a legal document |
| `GET`  | `/api/documents` | List all ingested documents |
| `GET`  | `/api/health` | Health check |

### Example: Chat Request

```bash
curl -X POST http://localhost:8000/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "message": "What are my rights as a tenant if my landlord refuses repairs?",
    "conversation_id": "conv_123"
  }'
```

### Example: Chat Response

```json
{
  "reply": "As a tenant, you generally have the right to a habitable living space...",
  "sources": [
    {
      "document": "Tenant Rights Act - Section 42",
      "relevance_score": 0.92
    }
  ],
  "conversation_id": "conv_123",
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

### Ingestion Pipeline

```bash
# Ingest all documents from data/raw/
python scripts/ingest.py --input-dir data/raw

# Ingest a single file
python scripts/ingest.py --file data/raw/tenant_rights.pdf

# Check ingestion status
python scripts/ingest.py --status
```

---

## 🧪 Testing

### Backend Tests

```bash
cd backend
source venv/bin/activate
pytest tests/ -v --cov=app
```

### Frontend Tests

```bash
cd frontend
npm run test
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
docker-compose -f docker-compose.yml up -d --build

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Environment Checklist for Production

- [ ] Set strong API keys in `.env`
- [ ] Enable HTTPS
- [ ] Set `DEBUG=false`
- [ ] Configure CORS for your domain only
- [ ] Set up rate limiting
- [ ] Enable logging and monitoring
- [ ] Add legal disclaimer to all responses
- [ ] Review data privacy compliance (GDPR, etc.)

---

## 🤝 Contributing Guidelines

1. **Never push directly to `main` or `develop`**
2. **Every PR needs at least 1 approval**
3. **Write tests for new features**
4. **Update this README if you change setup steps**
5. **Keep `.env` out of git** (it's in `.gitignore`)
6. **Document your code** — use docstrings and type hints

---

## 🗺️ Roadmap

### Phase 1 — MVP (Weeks 1–3)
- [x] Project setup & README
- [ ] Basic FastAPI backend with chat endpoint
- [ ] RAG pipeline with ChromaDB
- [ ] Document ingestion script
- [ ] Simple React chat UI
- [ ] Legal disclaimer on all responses

### Phase 2 — Core Features (Weeks 4–6)
- [ ] Conversation history & context
- [ ] Source citation display in UI
- [ ] Multi-document type ingestion (PDF, DOCX)
- [ ] Prompt engineering for legal accuracy
- [ ] Basic test suite

### Phase 3 — Polish & Deploy (Weeks 7–8)
- [ ] Docker Compose deployment
- [ ] Response quality evaluation
- [ ] Rate limiting & error handling
- [ ] UI/UX improvements
- [ ] CI/CD pipeline

### Phase 4 — Stretch Goals
- [ ] Multi-language support
- [ ] Voice input
- [ ] Document drafting assistance
- [ ] User authentication
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