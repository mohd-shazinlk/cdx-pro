const AuthService = require('../services/authService');

const validateEmail = (email) => /^[^@\s]+@[^@\s]+\.[^@\s]+$/.test((email || '').trim());

const validatePassword = (password) => typeof password === 'string' && password.length >= 8;

const register = async (req, res, next) => {
  try {
    const { name, email, password } = req.body;
    if (!name || String(name).trim().length < 2) return res.status(400).json({ message: 'Name must be at least 2 characters.' });
    if (!validateEmail(email)) return res.status(400).json({ message: 'Invalid email format.' });
    if (!validatePassword(password)) return res.status(400).json({ message: 'Password must be at least 8 characters.' });
    const user = await AuthService.register({ name, email, password });
    res.status(201).json({
      message: 'Registered successfully. OTP sent to email.',
      user
    });
  } catch (error) {
    next(error);
  }
};

const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    if (!validateEmail(email)) return res.status(400).json({ message: 'Invalid email format.' });
    if (!validatePassword(password)) return res.status(400).json({ message: 'Password must be at least 8 characters.' });
    const payload = await AuthService.login({ email, password });
    res.status(200).json(payload);
  } catch (error) {
    next(error);
  }
};

const sendOtp = async (req, res, next) => {
  try {
    const { email } = req.body;
    if (!validateEmail(email)) return res.status(400).json({ message: 'Invalid email format.' });
    await AuthService.sendOtp(email, 'reset');
    res.status(200).json({ message: 'OTP sent successfully.' });
  } catch (error) {
    next(error);
  }
};

const verifyOtp = async (req, res, next) => {
  try {
    const { email, otpCode, context } = req.body;
    if (!validateEmail(email)) return res.status(400).json({ message: 'Invalid email format.' });
    if (!otpCode || String(otpCode).trim().length < 4) return res.status(400).json({ message: 'Invalid OTP code.' });
    const result = await AuthService.verifyOtp({ email, otpCode: String(otpCode).trim(), context: context || 'verification' });
    res.status(200).json(result);
  } catch (error) {
    next(error);
  }
};

const resetPassword = async (req, res, next) => {
  try {
    const { email, otpCode, newPassword } = req.body;
    if (!validateEmail(email)) return res.status(400).json({ message: 'Invalid email format.' });
    if (!otpCode || String(otpCode).trim().length < 4) return res.status(400).json({ message: 'Invalid OTP code.' });
    if (!validatePassword(newPassword)) return res.status(400).json({ message: 'Password must be at least 8 characters.' });
    await AuthService.resetPassword({ email, otpCode: String(otpCode).trim(), newPassword });
    res.status(200).json({ message: 'Password reset successfully.' });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  register,
  login,
  sendOtp,
  verifyOtp,
  resetPassword
};
