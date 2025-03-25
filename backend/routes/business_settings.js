const express = require('express');
const router = express.Router();
const db = require('../db');
const authMiddleware = require('../models/middleware_auth');

router.get('/', authMiddleware, async (req, res) => {
  try {
    const businessId = req.user.business_id;
    const [business] = await db.query('SELECT * FROM businesses WHERE business_id = ?', [businessId]);
    const [subscription] = await db.query('SELECT * FROM subscriptions WHERE business_id = ? ORDER BY end_date DESC LIMIT 1', [businessId]);
    const [paymentMethod] = await db.query('SELECT * FROM payment_methods WHERE business_id = ? LIMIT 1', [businessId]);
    res.json({ business, subscription, paymentMethod });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching settings' });
  }
});

router.put('/update', authMiddleware, async (req, res) => {
  try {
    const businessId = req.user.business_id;
    const { business, action } = req.body;

    if (business) {
      await db.query('UPDATE businesses SET ? WHERE business_id = ?', [business, businessId]);
    }
    if (action === 'upgrade_ai') {
      await db.query('UPDATE businesses SET has_ai_access = 1 WHERE business_id = ?', [businessId]);
    }
    if (action === 'update_payment') {
      await db.query('UPDATE payment_methods SET payment_type = "paypal" WHERE business_id = ?', [businessId]);
    }

    res.json({ message: 'Settings updated' });
  } catch (error) {
    res.status(500).json({ message: 'Update failed' });
  }
});

module.exports = router;
