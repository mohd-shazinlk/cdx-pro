const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');
const UserModel = require('../models/userModel');
const HttpError = require('../utils/httpError');
const { signToken } = require('../utils/token');
const { generateOtp } = require('../utils/otp');
const { sendOtpEmail } = require('./mailService');

// OTP expires in 10 minutes for both signup verification and password reset flows.
const otpExpiryDate = () => new Date(Date.now() + 10 * 60 * 1000);

const register = async ({ name, email, password }) => {
  const normalizedEmail = email.trim().toLowerCase();
  const existingUser = await UserModel.findUserByEmail(normalizedEmail);
  if (existingUser) throw new HttpError(409, 'Email is already registered.');

  const hashedPassword = await bcrypt.hash(password, 12);
  const otpCode = generateOtp();
  const otpExpiry = otpExpiryDate();

  const user = await UserModel.createUser({
    id: uuidv4(),
    name,
    email: normalizedEmail,
    password: hashedPassword,
    otpCode,
    otpExpiry
  });

  await sendOtpEmail(normalizedEmail, otpCode, 'verification');
  return user;
};

const login = async ({ email, password }) => {
  const normalizedEmail = email.trim().toLowerCase();
  const user = await UserModel.findUserByEmail(normalizedEmail);
  if (!user) throw new HttpError(401, 'Invalid credentials.');

  const isPasswordValid = await bcrypt.compare(password, user.password);
  if (!isPasswordValid) throw new HttpError(401, 'Invalid credentials.');
  if (!user.is_verified) throw new HttpError(403, 'Please verify your email first.');

  // Include minimal claims in JWT payload for secure stateless authentication.
  const token = signToken({ sub: user.id, email: user.email });
  return {
    token,
    user: {
      id: user.id,
      name: user.name,
      email: user.email,
      isVerified: user.is_verified
    }
  };
};

const sendOtp = async (email, context = 'reset') => {
  const normalizedEmail = email.trim().toLowerCase();
  const user = await UserModel.findUserByEmail(normalizedEmail);
  if (!user) throw new HttpError(404, 'User not found.');

  const otpCode = generateOtp();
  const otpExpiry = otpExpiryDate();
  await UserModel.updateOtp(normalizedEmail, otpCode, otpExpiry);
  await sendOtpEmail(normalizedEmail, otpCode, context);
};

const verifyOtp = async ({ email, otpCode, context = 'verification' }) => {
  const normalizedEmail = email.trim().toLowerCase();
  const user = await UserModel.findUserByEmail(normalizedEmail);
  if (!user) throw new HttpError(404, 'User not found.');
  if (!user.otp_code || !user.otp_expiry) throw new HttpError(400, 'OTP is not requested.');
  if (new Date(user.otp_expiry) < new Date()) throw new HttpError(400, 'OTP expired.');
  if (user.otp_code !== otpCode) throw new HttpError(400, 'Invalid OTP code.');

  if (context === 'verification') {
    await UserModel.verifyUserOtp(normalizedEmail);
  }

  return { message: 'OTP verified successfully.' };
};

const resetPassword = async ({ email, otpCode, newPassword }) => {
  const normalizedEmail = email.trim().toLowerCase();
  await verifyOtp({ email: normalizedEmail, otpCode, context: 'reset' });
  const hashedPassword = await bcrypt.hash(newPassword, 12);
  await UserModel.updatePasswordByEmail(normalizedEmail, hashedPassword);
};

module.exports = {
  register,
  login,
  sendOtp,
  verifyOtp,
  resetPassword
};
