const express = require('express');
const router = express.Router();
const Question = require('../models/Question'); // لازم يكون عندك موديل Question

// إضافة سؤال جديد
router.post('/questions', async (req, res) => {
  try {
    const { userId, questionText } = req.body;

    const newQuestion = new Question({
      userId,
      questionText,
      createdAt: new Date()
    });

    await newQuestion.save();

    res.status(201).json({ message: 'تم إرسال السؤال بنجاح', question: newQuestion });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'حدث خطأ أثناء إرسال السؤال' });
  }
});

// جلب كل الأسئلة
router.get('/questions', async (req, res) => {
  try {
    const questions = await Question.find().sort({ createdAt: -1 });
    res.json(questions);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'حدث خطأ أثناء جلب الأسئلة' });
  }
});

module.exports = router;
