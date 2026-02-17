# Full-Stack Authentication System

Production-ready authentication stack with Flutter frontend and Node.js/Express backend.

## Project Structure

```text
.
├── backend/
│   └── authentication/
│       ├── package.json
│       ├── .env.example
│       ├── sql/
│       │   └── schema.sql
│       └── src/
│           ├── app.js
│           ├── server.js
│           ├── config/
│           ├── controllers/
│           ├── middleware/
│           ├── models/
│           ├── routes/
│           ├── services/
│           └── utils/
└── frontend/
    └── authentication/
        ├── pubspec.yaml
        └── lib/
            ├── core/
            ├── data/
            ├── domain/
            └── presentation/
```

## Backend Setup (Node.js + Express + PostgreSQL)

### 1) Install dependencies
```bash
cd backend/authentication
npm install
```

### 2) Configure environment
```bash
cp .env.example .env
```
Edit `.env` with PostgreSQL, JWT, SMTP values.

### 3) Create PostgreSQL database and table
```sql
CREATE DATABASE auth_db;
\c auth_db;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(120) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  is_verified BOOLEAN DEFAULT FALSE,
  otp_code VARCHAR(10),
  otp_expiry TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 4) Run server
```bash
npm run dev
```

Backend base URL: `http://localhost:5000/api/auth`

### API Endpoints
- `POST /register`
- `POST /login`
- `POST /send-otp`
- `POST /verify-otp`
- `POST /reset-password`

## Frontend Setup (Flutter + Provider)

### 1) Install Flutter packages
```bash
cd frontend/authentication
flutter pub get
```

### 2) Run app
```bash
flutter run
```

### Flutter dependencies in `pubspec.yaml`
- `provider`
- `http`
- `shared_preferences`
- `flutter_secure_storage`

## Architecture Notes

- Backend follows MVC with isolated routes/controllers/services/models.
- Frontend follows clean architecture layering (`domain/data/presentation`) + Provider state handling.
- JWT is stored securely with `flutter_secure_storage`.
- OTP flows are supported for account verification and password reset.
- Splash performs JWT login-state check and routes to Login/Home accordingly.
- Password hashing uses `bcryptjs`.

## Production Readiness Checklist

- Structured error handling middleware.
- Environment variable isolation with `.env`.
- CORS configured by explicit frontend origin.
- JWT verification middleware included.
- Clean service separation for auth/OTP/mail responsibilities.
