const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  await prisma.expense.createMany({
    data: [
      { amount: 15.50, category: 'Food', note: 'Lunch', date: new Date() },
      { amount: 42.00, category: 'Transport', note: 'Bus pass', date: new Date() },
      { amount: 89.99, category: 'Shopping', date: new Date(Date.now() - 86400000) },
    ],
  });
  console.log('Seed completed.');
}

main()
  .then(() => prisma.$disconnect())
  .catch((e) => {
    console.error(e);
    prisma.$disconnect();
  });
