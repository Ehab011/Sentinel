const CATEGORIES = ['Food', 'Transport', 'Bills', 'Shopping', 'Other'];

function parseDate(str) {
  if (!str || typeof str !== 'string') return null;
  const trimmed = str.trim();
  const isoMatch = trimmed.match(/^\d{4}-\d{2}-\d{2}(T[\d:.+-]+Z?)?$/);
  const simpleMatch = trimmed.match(/^\d{4}-\d{2}-\d{2}$/);
  if (isoMatch || simpleMatch) {
    const d = new Date(trimmed);
    return isNaN(d.getTime()) ? null : d;
  }
  return null;
}

function validateCreateExpense(req, res, next) {
  const { amount, category, note, date } = req.body;
  const errors = [];

  const num = Number(amount);
  if (typeof amount === 'undefined' || amount === null || amount === '' || isNaN(num) || num <= 0) {
    errors.push('amount must be a positive number');
  }

  if (!category || typeof category !== 'string' || category.trim() === '') {
    errors.push('category is required and must be non-empty');
  } else if (!CATEGORIES.includes(category.trim())) {
    errors.push(`category must be one of: ${CATEGORIES.join(', ')}`);
  }

  const parsedDate = parseDate(date);
  if (!date || !parsedDate) {
    errors.push('date is required and must be valid (ISO or YYYY-MM-DD)');
  }

  if (errors.length > 0) {
    return res.status(400).json({ error: errors.join('; ') });
  }

  req.validated = {
    amount: num,
    category: category.trim(),
    note: note != null ? String(note).trim() || null : null,
    date: parsedDate,
  };
  next();
}

function validateQueryDates(req, res, next) {
  const { from, to } = req.query;
  if (from) {
    const d = parseDate(from);
    if (!d) return res.status(400).json({ error: 'from must be valid date (YYYY-MM-DD)' });
    req.queryFrom = d;
  }
  if (to) {
    const d = parseDate(to);
    if (!d) return res.status(400).json({ error: 'to must be valid date (YYYY-MM-DD)' });
    req.queryTo = d;
  }
  next();
}

function validateMonth(req, res, next) {
  const m = req.query.month;
  const match = m ? String(m).trim().match(/^(\d{4})-(\d{2})$/) : null;
  if (m && !match) {
    return res.status(400).json({ error: 'month must be YYYY-MM' });
  }
  req.monthParam = match ? `${match[1]}-${match[2]}` : null;
  next();
}

module.exports = {
  validateCreateExpense,
  validateQueryDates,
  validateMonth,
  parseDate,
  CATEGORIES,
};
