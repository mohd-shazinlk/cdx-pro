const express = require('express');
const cors = require('cors');
const env = require('./config/env');
const authRoutes = require('./routes/authRoutes');
const { errorHandler } = require('./middleware/errorMiddleware');

const app = express();

app.use(cors({ origin: env.frontendOrigin, credentials: true }));
app.use(express.json());

app.get('/health', (req, res) => {
  res.status(200).json({ message: 'Authentication service is running.' });
});

app.use('/api/auth', authRoutes);

app.use(errorHandler);

module.exports = app;
