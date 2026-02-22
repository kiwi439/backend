import core from '@actions/core';
import nodemailer from 'nodemailer';

const TO = 'siwiec.michal724@gmail.com';
const SMTP = {
  host: 'smtp.gmail.com',
  port: 587,
  user: 'siwiec.michal724@gmail.com',
};

async function run() {
  try {
    const pass = core.getInput('smtp-password', { required: true });

    const transporter = nodemailer.createTransport({
      host: SMTP.host,
      port: SMTP.port,
      secure: false,
      auth: { user: SMTP.user, pass },
    });

    await transporter.sendMail({
      from: SMTP.user,
      to: TO,
      subject: 'Deploy is doable - each tests passed',
      text: 'Deploy is doable - each tests passed. You can deploy now.',
    });

    core.info('Email sent successfully.');
  } catch (error) {
    core.setFailed(error.message);
  }
}

run();
