const nodemailer = require('nodemailer');
const env = require('../config/env');

const transporter = nodemailer.createTransport({
  host: env.smtpHost,
  port: env.smtpPort,
  secure: false,
  auth: {
    user: env.smtpUser,
    pass: env.smtpPass
  }
});

const sendOtpEmail = async (to, otpCode, context = 'verification') => {
  const subject = context === 'reset' ? 'Reset Your Password OTP' : 'Verify Your Account OTP';
  const html = `
    <div style="font-family: Arial, sans-serif; line-height: 1.6;">
      <h2>${subject}</h2>
      <p>Use the OTP below. It expires in 10 minutes.</p>
      <div style="font-size: 24px; font-weight: bold; letter-spacing: 3px;">${otpCode}</div>
    </div>
  `;

  await transporter.sendMail({
    from: env.mailFrom,
    to,
    subject,
    html
  });
};

module.exports = { sendOtpEmail };
