const cds = require('@sap/cds');
const crypto = require('crypto');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');

const otpStore = new Map();
const OTP_EXPIRY_MS = 5 * 60 * 1000;
const RESEND_COOLDOWN_MS = 30 * 1000;
const MAX_ATTEMPTS = 3;
const JWT_SECRET = "@@@@" || '@@@@';
const JWT_EXPIRY = '5s';

// Ethereal transporter for testing emails
const transporter = nodemailer.createTransport({
    host: 'smtp.ethereal.email',
    port: 587,
    auth: {
        user: 'ian.legros31@ethereal.email',
        pass: '5bkj263yq8c1SbBBng'
    }
});

const generateOTP = () => Math.floor(100000 + Math.random() * 900000).toString();

const hashOTP = otp => crypto.createHash('sha256').update(otp).digest('hex');

const sendEmail = async (email, otp) => {
    const mailOptions = {
        from: '"abhi technologys " <ian.legros31@ethereal.email>',
        to: email,
        subject: 'Your OTP Code',
        text: `Your OTP code is ${otp}. It will expire in 5 minutes.`,
        html: `<p>Your OTP code is <b>${otp}</b>. It will expire in 5 minutes.</p>`
    };

    try {
        const info = await transporter.sendMail(mailOptions);
        console.log(`📧 OTP ${otp} sent to ${email}`);
        console.log('Preview URL: %s', nodemailer.getTestMessageUrl(info));  // Ethereal preview link
        return true;
    } catch (error) {
        console.error('Error sending email:', error);
        throw new Error('Failed to send OTP email.');
    }
};

const loginCheck = async (req) => {
    const { email, otp: userOtp, action } = req.data;

    if (!email || email.trim() === '') {
        return { message: "Email is required." };
    }

    const normalizedEmail = email.toLowerCase();

    const db = await cds.connect.to("db");
    const { EmployeesAuthentication } = cds.entities('sumo_management');

    const empData = await db.run(
        SELECT.one.from(EmployeesAuthentication).where({ username: normalizedEmail })
    );

    // Hide user presence
    if (!empData) {
        return { message: "If the email is registered, an OTP has been sent." };
    }

    const existing = otpStore.get(normalizedEmail);
    const now = Date.now();

    // Resend OTP
    if (action === 'resend') {
        if (existing && now - existing.lastSent < RESEND_COOLDOWN_MS) {
            return { message: "Please wait before resending OTP." };
        }

        const otp = generateOTP();
        otpStore.set(normalizedEmail, {
            otpHash: hashOTP(otp),
            expiresAt: now + OTP_EXPIRY_MS,
            lastSent: now,
            attempts: 0
        });

        await sendEmail(normalizedEmail, otp);
        return { message: `OTP resent to ${normalizedEmail}` };
    }

    // OTP verification
    if (userOtp) {
        if (!existing) {
            return { message: "No OTP found. Please request a new one." };
        }

        if (now > existing.expiresAt) {
            otpStore.delete(normalizedEmail);
            return { message: "OTP expired. Please request a new one." };
        }

        if (existing.attempts >= MAX_ATTEMPTS) {
            otpStore.delete(normalizedEmail);
            return { message: "Too many failed attempts. Please request a new OTP." };
        }

        if (hashOTP(userOtp) !== existing.otpHash) {
            existing.attempts++;
            otpStore.set(normalizedEmail, existing);
            return { message: "Invalid OTP." };
        }

        otpStore.delete(normalizedEmail);
        const token = jwt.sign({ email: normalizedEmail }, JWT_SECRET, { expiresIn: JWT_EXPIRY });

        return {
            message: `User ${normalizedEmail} logged in successfully.`,
            token
        };
    }

    // Send OTP
    if (existing && now - existing.lastSent < RESEND_COOLDOWN_MS) {
        return { message: "OTP already sent recently. Please wait before requesting again." };
    }

    const otp = generateOTP();
    otpStore.set(normalizedEmail, {
        otpHash: hashOTP(otp),
        expiresAt: now + OTP_EXPIRY_MS,
        lastSent: now,
        attempts: 0
    });

    await sendEmail(normalizedEmail, otp);
    return { message: `OTP sent to ${normalizedEmail}` };
};

module.exports = { loginCheck };
