# Admin Portal Using Database Schema

This is a simple admin portal that allows the root user to manage tenants and view their stats.

## Backend

### Tech Stack
- FastAPI
- PostgreSQL
- SQLAlchemy

### API Endpoints
- GET /admin/users/stats | Returns a list of users with their stats
- POST /admin/users/{user_id}/upgrade | Changes the tier of a user

## Frontend

### Features
- User Stats
- Toggle Tenant Tier
- Search Users
- Pagination, Pie Chart

## Tests - pytest

- DB connection test
- API endpoints tests 

## Setup 

### 1. setup python environment

bash
```
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 2. setup db connection and populate db

bash
```
python setup_local_db.py
```

### 3. run the app

#### Backend

```
uvicorn src.admin_api:app --reload --port 8000;      
```

#### Frontend

```
npm run dev
```

- backend: http://localhost:8000
- frontend: http://localhost:3000


## Pending

- Add unleash feature flags to the UI
- Add CI/CD pipeline
- Add terraform for infrastructure

