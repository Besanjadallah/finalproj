const mongoose = require('mongoose');

const answerSchema = new mongoose.Schema({
  text: String,
  user: String,
  date: Date,
});

const questionSchema = new mongoose.Schema({
  text: String,
  user: String,
  date: Date,
  answers: [answerSchema],
});

module.exports = mongoose.model('Question', questionSchema);
