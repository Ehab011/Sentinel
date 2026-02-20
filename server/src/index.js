require('express-async-errors');
const express = require('express');
const cors = require('cors');
const expensesRouter = require('./routes/expenses');
const summaryRouter = require('./routes/summary');

process.on('uncaughtException', (err) => {
  console.error('[FATAL] uncaughtException:', err);
  process.exit(1);
});
process.on('unhandledRejection', (reason, promise) => {
  console.error('[FATAL] unhandledRejection:', reason);
  process.exit(1);
});

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json({ limit: '1mb' }));

app.use('/api/expenses', expensesRouter);
app.use('/api/summary', summaryRouter);

app.get('/health', (req, res) => res.json({ status: 'ok' }));

app.use((err, req, res, next) => {
  if (res.headersSent) return next(err);
  console.error(err?.message ?? err);
  const msg = err?.message ?? String(err);
  res.status(500).json({ error: msg });
});

app.listen(PORT, '0.0.0.0');
