const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const { GoogleGenAI } = require("@google/genai");

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json({ limit: "20mb" }));

const ai = new GoogleGenAI({
  apiKey: process.env.GEMINI_API_KEY,
});

app.post("/generate-image", async (req, res) => {
  try {
    const { text, emoji } = req.body;

    if (!text) {
      return res.status(400).json({
        error: "Günlük yazısı boş gönderildi.",
      });
    }

    const prompt = `
Aşağıdaki günlük yazısını gerçek bir resim sahnesine dönüştür.

Duygu: ${emoji || "😊"}

Günlük yazısı:
${text}

Stil:
- Duygusal, sıcak, sinematik
- Eski büyülü günlük atmosferi
- Yumuşak ışık
- Gerçekçi ama masalsı
- İnsan yüzü çok belirgin olmasın
- Günlükte yaşanan duyguyu görsel olarak anlat
`;

    const response = await ai.models.generateContent({
      model: "gemini-2.5-flash-image",
      contents: prompt,
    });

    let imageBase64 = null;
    let mimeType = "image/png";
    let textResult = "";

    const parts = response.candidates?.[0]?.content?.parts || [];

    for (const part of parts) {
      if (part.text) {
        textResult += part.text;
      }

      if (part.inlineData) {
        imageBase64 = part.inlineData.data;
        mimeType = part.inlineData.mimeType || "image/png";
      }
    }

    if (!imageBase64) {
      return res.status(500).json({
        error: "Gemini resim üretmedi.",
        text: textResult,
      });
    }

    res.json({
      imageBase64,
      mimeType,
      text: textResult,
    });
  } catch (e) {
    console.error(e);

    res.status(500).json({
      error: e.toString(),
    });
  }
});

app.post("/ai-support", async (req, res) => {
  try {
    const { title, message } = req.body;

    if (!message) {
      return res.status(400).json({
        error: "Mesaj boş gönderildi.",
      });
    }

    const prompt = `
Sen profesyonel bir aile ilişkileri ve duygu destek danışmanısın.

Kategori:
${title || "Genel Destek"}

Kullanıcının mesajı:
${message}

Cevap kuralları:
- Türkçe cevap ver.
- Empati kur.
- Suçlayıcı konuşma.
- Kısa, net ve uygulanabilir öneriler ver.
- Kaynana, elti, görümce, eş, çocuk ve aile ilişkilerinde sınır koymayı nazik anlat.
- Tehlike, şiddet veya ağır psikolojik durum varsa profesyonel destek önermeyi unutma.
`;

    const response = await ai.models.generateContent({
      model: "gemini-2.5-flash",
      contents: prompt,
    });

    res.json({
      answer: response.text || "Şu anda cevap oluşturulamadı.",
    });
  } catch (e) {
    console.error(e);

    res.status(500).json({
      error: e.toString(),
    });
  }
});

app.listen(process.env.PORT || 3000, () => {
  console.log("Server çalışıyor: http://localhost:3000");
});