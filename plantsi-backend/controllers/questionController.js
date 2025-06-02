const Question = require('../models/Question');

// إضافة سؤال جديد
const addQuestion = async (req, res) => {
  try {
    const { text, user } = req.body;
    const newQuestion = new Question({
      text,
      user,
      date: new Date(),
      answers: [],
    });
    await newQuestion.save();
    res.status(201).json(newQuestion);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// جلب جميع الأسئلة
const getAllQuestions = async (req, res) => {
  try {
    const questions = await Question.find().sort({ date: -1 });
    res.json(questions);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// إضافة رد على سؤال
const addAnswer = async (req, res) => {
  try {
    const { questionId } = req.params;
    const { text, user } = req.body;

    const question = await Question.findById(questionId);
    question.answers.push({ text, user, date: new Date() });

    await question.save();
    res.json(question);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = { addQuestion, getAllQuestions, addAnswer };

