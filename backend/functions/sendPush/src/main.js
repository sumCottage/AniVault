import admin from 'firebase-admin';

export default async ({ req, res, log, error }) => {
  try {
    log('Function invoked');

    if (!admin.apps.length) {
      log('Initializing Firebase Admin');
      admin.initializeApp({
        credential: admin.credential.cert({
          projectId: process.env.FIREBASE_PROJECT_ID,
          clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
          privateKey: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
        }),
      });
    }

    const body = req.body ? JSON.parse(req.body) : {};
    log('Request body parsed', body);

    const { fcmToken, title, message } = body;

    if (!fcmToken) {
      error('Missing FCM token');
      return res.json({ success: false, error: 'Missing fcmToken' }, 400);
    }

    log('Sending push notification');

    const response = await admin.messaging().send({
      token: fcmToken,
      notification: {
        title: title || 'Test',
        body: message || 'Push from Appwrite',
      },
    });

    log('Push sent successfully', response);

    return res.json({
      success: true,
      messageId: response,
    });
  } catch (e) {
    error('Unhandled error', e.message);
    return res.json({ success: false, error: e.message }, 500);
  }
};
