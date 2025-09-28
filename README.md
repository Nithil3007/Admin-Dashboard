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
npm install
```

```
npm run dev
```

- backend: http://localhost:8000
- frontend: http://localhost:3000

## Screenshots

### Free Trial Tenants 
<img width="1709" height="951" alt="Screenshot 2025-09-27 at 10 39 16 PM" src="https://github.com/user-attachments/assets/e5350ff3-b04e-4570-a46a-04da578d21d2" />

### First Page - initial
<img width="1709" height="951" alt="Screenshot 2025-09-27 at 10 39 26 PM" src="https://github.com/user-attachments/assets/f7aa4c41-e669-44f9-9dda-a75c87d72041" />

### Tenants' Tiers table - initial
<img width="1709" height="959" alt="Screenshot 2025-09-27 at 10 39 47 PM" src="https://github.com/user-attachments/assets/9e68ee2a-faf6-4b6e-a9d4-77ca8ef4777e" />

### Changed Dr. Alice Wonderland status from Professional to Basic
<img width="1709" height="959" alt="Screenshot 2025-09-27 at 10 40 17 PM" src="https://github.com/user-attachments/assets/fee562c9-0d33-465f-8e5c-43f291e789b6" />

### Tenants' Tiers table - final
<img width="1709" height="959" alt="Screenshot 2025-09-27 at 10 40 33 PM" src="https://github.com/user-attachments/assets/aed0a65f-d9d4-482d-b0cf-6a33893e44b2" />


## Pending

- Add unleash feature flags to the UI
- Add CI/CD pipeline
- Add terraform for infrastructure


