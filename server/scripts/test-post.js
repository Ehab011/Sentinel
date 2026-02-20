const http = require('http');

const PORT = process.env.PORT || 3001;
const body = JSON.stringify({
  amount: 25.99,
  category: 'Food',
  note: 'API test from script',
  date: '2026-02-20',
});

const req = http.request(
  {
    hostname: 'localhost',
    port: PORT,
    path: '/api/expenses',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Content-Length': Buffer.byteLength(body),
    },
  },
  (res) => {
    const chunks = [];
    res.on('data', (ch) => chunks.push(ch));
    res.on('end', () => {
      const data = Buffer.concat(chunks).toString('utf8');
      console.log(res.statusCode, data || '')
    });
  }
);
req.on('error', (e) => console.error('Connection error:', e.message));
req.write(body);
req.end();
