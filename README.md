# Task Management Web Application

A full-stack task manager with **username/password authentication**, responsive UI, REST API, and persistent storage using **Neon** (serverless PostgreSQL).

## Features

- **Authentication**: Register and log in with username and password (sessions, bcrypt)
- **Frontend**: Responsive HTML, CSS, and vanilla JavaScript
- **Task fields**: Title, Description, Status (Pending / In Progress / Completed)
- **CRUD**: Create, view, update, and delete tasks (scoped per user)
- **Filters**: Filter tasks by status
- **Backend**: Node.js with Express
- **Database**: PostgreSQL via [Neon](https://neon.tech)
- **Deployment**: Render.com blueprint included
- **Testing**: API tests with Node.js test runner

## Prerequisites

- Node.js 18+
- [Neon](https://neon.tech) account (free tier)

## Setup

### 1. Clone and install

```bash
git clone <your-repo-url>
cd todo-list
npm install
```

### 2. Neon database

1. Go to [Neon Console](https://console.neon.tech) and create a project.
2. Copy the **connection string** from the dashboard.

### 3. Environment

```bash
cp .env.example .env
```

Edit `.env`:

```env
DATABASE_URL=postgresql://user:password@host/database?sslmode=require
SESSION_SECRET=use-a-long-random-string-in-production
PORT=3000
```

### 4. Init database and run

```bash
npm run init-db
npm start
```

Open [http://localhost:3000](http://localhost:3000). You will be redirected to **Log in**. Use **Register** to create an account (username + password, min 6 chars), then add tasks.

### 5. Development

```bash
npm run dev
```

## Project structure

```
todo-list/
├── public/
│   ├── index.html       # App (tasks) — requires login
│   ├── login.html       # Login / Register
│   ├── css/style.css
│   └── js/
│       ├── app.js       # Task list, CRUD, auth check
│       └── login.js     # Login/register forms
├── server/
│   ├── index.js         # Express, session, routes
│   ├── db.js            # PostgreSQL pool (Neon)
│   ├── initDb.js        # users, tasks, session tables
│   ├── middleware/auth.js
│   └── routes/
│       ├── auth.js      # Register, login, logout, me
│       └── tasks.js     # CRUD (scoped by user_id)
├── test/
│   └── api.test.js      # API tests
├── .env.example
├── render.yaml          # Optional Render.com deploy
├── package.json
└── README.md
```

## API reference

### Auth (no auth required for these)

| Method | Path | Description |
|--------|------|-------------|
| POST | /api/auth/register | Register (body: `username`, `password`) |
| POST | /api/auth/login | Login (body: `username`, `password`) |
| POST | /api/auth/logout | Logout (session destroyed) |
| GET | /api/auth/me | Current user (401 if not logged in) |

### Tasks (require login; session cookie)

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/tasks | List current user's tasks. Query: `?status=pending` \| `in_progress` \| `completed` |
| GET | /api/tasks/:id | Get one task |
| POST | /api/tasks | Create (body: `title`, `description?`, `status?`) |
| PUT | /api/tasks/:id | Update (body: `title?`, `description?`, `status?`) |
| DELETE | /api/tasks/:id | Delete |

All task responses use: `{ id, title, description, status, created_at, updated_at }`.  
Valid status: `pending`, `in_progress`, `completed`.

**Why tasks might not show**

- Not logged in → redirect to `/login`. Use **Register** or **Log in** and ensure cookies are allowed.
- Wrong or missing `DATABASE_URL` → run `npm run init-db` and set `.env` with your Neon connection string.
- API returns 401 → frontend redirects to login; log in again.

## Testing

```bash
npm test
```

Uses Node.js built-in test runner. Tests hit the **tasks API** (with a test user/session). Set `DATABASE_URL` and run `npm run init-db` first. See `test/api.test.js` for coverage.

## Deployment (e.g. Render.com)

1. Push the repo to GitHub.
2. On [Render](https://render.com), create a **Web Service**, connect the repo.
3. Set **Environment**:
   - `DATABASE_URL` = your Neon connection string
   - `SESSION_SECRET` = long random string (Render can generate)
   - `NODE_ENV` = `production`
4. Build: `npm install`  
   Start: `npm run init-db 2>/dev/null; npm start`  
   (Or use the `render.yaml` blueprint if your plan supports it.)
5. Use the generated URL (e.g. `https://todo-list-xxx.onrender.com`). Optional: add a deployed link in the README.

**Note**: In production, use HTTPS and a strong `SESSION_SECRET`; sessions are stored in PostgreSQL via `connect-pg-simple`.

## Evaluation checklist

- **Code quality**: Modular server, validation, error handling, escaped output
- **Fundamentals**: REST, SQL, responsive layout, auth (username/password)
- **Organisation**: Clear split between public, server, middleware, routes
- **Bonus**: Authentication, filters, deployment config, documentation, testing

## License

MIT
