const express = require('express');
const router = express.Router();
const multer = require('multer');
const fs = require('fs');
const axios = require('axios');

const upload = multer({ dest: 'uploads/' });

const API_KEY = 'vBRjGxBXSP1EVkoJ2PT0E1hFxiRF9ZobZPAreycdDq8ryHNMW0';

router.post('/analyze-plant', upload.single('image'), async (req, res) => {
  try {
    console.log('📥 تم استلام الطلب');

    const imageBase64 = fs.readFileSync(req.file.path, 'base64');
    console.log('📸 تم تحويل الصورة إلى base64');
    console.log("🚀 Using API KEY:", API_KEY);
    console.log("🔑 API KEY LENGTH:", API_KEY.length);

    const response = await axios({
      method: 'post',
      url: 'https://plant.id/api/v3/identification',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Api-Key': API_KEY
      },
      data: {
        images: [`data:image/jpeg;base64,${imageBase64}`],
        modifiers: {
          classification_level: "species",
          health: "auto",
          similar_images: true
        },
        plant_details: ["common_names", "url", "name_authority", "wiki_description", "taxonomy"],
        organs: ['leaf']
      }
    });

    console.log('✅ تم تحليل الصورة بنجاح من API');

    fs.unlinkSync(req.file.path);
    console.log('🧹 تم حذف الملف المؤقت');

    res.json(response.data);

  } catch (error) {
    fs.unlinkSync(req.file.path);
    const status = error.response?.status || 500;
    const message = error.response?.data || error.message;

    console.error("❌ تحليل النبتة فشل:", message);
    console.log(" error code ", status);
    console.log("📨 error mes:", message);

    res.status(status).json({
      error: 'Failed to analyze plant',
      details: message
    });
  }
});

module.exports = router;
