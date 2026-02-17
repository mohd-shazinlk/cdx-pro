const pool = require('../config/database');

const baseSelect = `
  SELECT id, name, email, password, is_verified, otp_code, otp_expiry, created_at
  FROM users
`;

const createUser = async ({ id, name, email, password, otpCode, otpExpiry }) => {
  const query = `
    INSERT INTO users (id, name, email, password, is_verified, otp_code, otp_expiry)
    VALUES ($1, $2, $3, $4, $5, $6, $7)
    RETURNING id, name, email, is_verified, created_at;
  `;
  const values = [id, name, email, password, false, otpCode, otpExpiry];
  const result = await pool.query(query, values);
  return result.rows[0];
};

const findUserByEmail = async (email) => {
  const result = await pool.query(`${baseSelect} WHERE email = $1 LIMIT 1`, [email]);
  return result.rows[0] || null;
};

const findUserById = async (id) => {
  const result = await pool.query(`${baseSelect} WHERE id = $1 LIMIT 1`, [id]);
  return result.rows[0] || null;
};

const updateOtp = async (email, otpCode, otpExpiry) => {
  await pool.query('UPDATE users SET otp_code = $1, otp_expiry = $2 WHERE email = $3', [otpCode, otpExpiry, email]);
};

const verifyUserOtp = async (email) => {
  await pool.query(
    `UPDATE users
     SET is_verified = true,
         otp_code = NULL,
         otp_expiry = NULL
     WHERE email = $1`,
    [email]
  );
};

const updatePasswordByEmail = async (email, hashedPassword) => {
  await pool.query(
    `UPDATE users
     SET password = $1,
         otp_code = NULL,
         otp_expiry = NULL
     WHERE email = $2`,
    [hashedPassword, email]
  );
};

module.exports = {
  createUser,
  findUserByEmail,
  findUserById,
  updateOtp,
  verifyUserOtp,
  updatePasswordByEmail
};
