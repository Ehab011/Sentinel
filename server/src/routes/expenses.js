const { Router } = require('express');
const { PrismaClient } = require('@prisma/client');
const { validateCreateExpense, validateQueryDates } = require('../validation');

const router = Router();
const prisma = new PrismaClient();

router.post('/', validateCreateExpense, async (req, res) => {
  const { amount, category, note, date } = req.validated;
  const expense = await prisma.expense.create({
    data: {
      amount,
      category,
      note,
      date: date.toISOString ? date.toISOString() : date,
    },
  });
  res.status(201).json({
    id: expense.id,
    amount: expense.amount,
    category: expense.category,
    note: expense.note,
    date: expense.date.toISOString(),
  });
});

router.get('/', validateQueryDates, async (req, res) => {
  const { from, to, category } = req.query;
  const where = {};

  if (req.queryFrom) where.date = { ...where.date, gte: req.queryFrom };
  if (req.queryTo) {
    const end = new Date(req.queryTo);
    end.setHours(23, 59, 59, 999);
    where.date = { ...where.date, lte: end };
  }
  if (category && String(category).trim()) where.category = String(category).trim();

  const expenses = await prisma.expense.findMany({
    where,
    orderBy: { date: 'desc' },
  });
  console.log('[GET] expenses count:', expenses.length);

  res.json(
    expenses.map((e) => ({
      id: e.id,
      amount: e.amount,
      category: e.category,
      note: e.note,
      date: e.date.toISOString(),
    }))
  );
});

router.delete('/:id', async (req, res) => {
  const id = parseInt(req.params.id, 10);
  if (isNaN(id)) return res.status(400).json({ error: 'Invalid id' });

  const deleted = await prisma.expense.deleteMany({ where: { id } });
  if (deleted.count === 0) return res.status(404).json({ error: 'Expense not found' });
  res.json({ success: true });
});

module.exports = router;
