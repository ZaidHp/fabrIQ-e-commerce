const express = require('express');
const cors = require('cors');
const path = require('path');
require("dotenv").config();
const deleteExpiredOtps = require('./utils/otpCleanup');
const deleteExpiredTokens = require("./utils/deleteExpiredTokens");
const cron = require('node-cron');

const app = express();
const PORT = 8080;

const userRoutes = require("./routes/users");
const authRoutes = require("./routes/auth");
const productRoutes = require("./routes/products");
const orderRoutes = require('./routes/orders');
const customerRoutes = require('./routes/customers');
const dashboardRoutes = require('./routes/dashboard');
const reviewsProductRoutes = require("./routes/product_reviews");
const reviewsBusinessRoutes = require("./routes/business_reviews");
const paymentsRoutes = require("./routes/payments");
const businessSettingsRoutes = require("./routes/business_settings");

app.use(cors());
app.use(express.json());
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Routes
app.use("/api/users", userRoutes);
app.use("/api/auth", authRoutes);
app.use("/api/products", productRoutes);
app.use("/api/orders", orderRoutes);
app.use('/customers', customerRoutes);
app.use('/api/dashboard', dashboardRoutes);
app.use("/api/product_reviews", reviewsProductRoutes);
app.use("/api/business_reviews", reviewsBusinessRoutes);
app.use("/api/payments", paymentsRoutes);
app.use("/api/settings", businessSettingsRoutes);

cron.schedule('*/5 * * * *', () => {
  deleteExpiredOtps();
  deleteExpiredTokens();
});

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
