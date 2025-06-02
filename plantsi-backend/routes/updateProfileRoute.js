const express = require('express');
const router = express.Router();
const User = require('../models/User'); // تأكدي إنك عندك موديل اسمه User

// تعديل بيانات المستخدم
router.put('/updateProfile/:id', async (req, res) => {
  try {
    const userId = req.params.id;
    const { name, email } = req.body;

    const updatedUser = await User.findByIdAndUpdate(
      userId,
      { name, email },
      { new: true } // برجع النسخة الجديدة بعد التحديث
    );

    if (!updatedUser) {
      return res.status(404).json({ message: 'المستخدم غير موجود' });
    }

    res.json({
      message: 'تم تحديث البيانات بنجاح',
      user: updatedUser
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'حدث خطأ أثناء التحديث' });
  }
});

module.exports = router;
