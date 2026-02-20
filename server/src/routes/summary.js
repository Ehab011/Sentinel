const { Router } = require('express');
const { PrismaClient } = require('@prisma/client');
const { validateMonth } = require('../validation');

const router = Router();
const prisma = new PrismaClient();

router.get('/monthly', validateMonth, async (req, res) => {
  const monthStr = req.monthParam || (() => {
    const d = new Date();
    return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`;
  })();

  const [year, month] = monthStr.split('-').map(Number);
  const start = new Date(year, month - 1, 1);
  const end = new Date(year, month, 0, 23, 59, 59, 999);

  const expenses = await prisma.expense.findMany({
    where: { date: { gte: start, lte: end } },
  });

  const total = expenses.reduce((s, e) => s + e.amount, 0);
  const byCat = {};
  for (const e of expenses) {
    byCat[e.category] = (byCat[e.category] || 0) + e.amount;
  }
  const byCategory = Object.entries(byCat).map(([category, total]) => ({ category, total }));

  res.json({
    month: monthStr,
    total: Math.round(total * 100) / 100,
    byCategory,
  });
});

module.exports = router;
