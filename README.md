# Sentinel

> Expense tracker — Flutter client, Node.js API, SQLite.

---

## Quick start

**1. Server**

```bash
cd server
npm install
cp .env.example .env
npx prisma generate
npx prisma migrate dev --name init
npm run dev
```

**2. Client**

```bash
cd client
flutter pub get
flutter run
```

---

## Config

Edit `client/lib/config.dart` for the API base URL:

| Target | URL |
|--------|-----|
| Android emulator | `http://10.0.2.2:3001` |
| iOS simulator | `http://localhost:3001` |
| Real device | `http://YOUR_PC_IP:3001` |
