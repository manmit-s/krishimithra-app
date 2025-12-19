# 🌾 KrishiMithra – Farmer-First AI Chatbot

KrishiMithra is a **farmer-centric mobile AI chatbot application** designed to help farmers get **instant, reliable, and context-aware answers** to their agriculture and farming-related questions.  
Built with a **mobile-first mindset**, KrishiMithra bridges the gap between modern AI and grassroots agriculture.

This project was developed as part of **Smart India Hackathon (SIH) 2025**.

---

## 🚜 Problem Statement

Farmers often struggle to get:
- Timely agricultural guidance  
- Reliable information in their **native language**  
- Easy access to expert-level advice without middlemen  

KrishiMithra solves this by providing a **simple conversational interface** powered by AI, accessible directly from a mobile phone.

---

## ✨ Key Features

- 🤖 **AI-Powered Chatbot**  
  Uses **Google Gemini API** for intelligent, natural language responses.

- 🌐 **Multilingual UI Support**  
  - English  
  - Hindi  
  - Malayalam  
  *(As per SIH problem statement)*  
  > Chatbot itself can respond in **any language**, thanks to Gemini’s multilingual understanding.

- 📱 **Farmer-First Mobile App**  
  Built using **Flutter** for smooth performance and cross-platform support.

- 🔐 **Secure Authentication & Chat Storage**  
  - All user chats are securely stored in **Supabase**
  - Auth-protected access ensures data privacy

- ⚡ **Scalable Backend Architecture**  
  - Backend powered by **FastAPI**
  - Clean API separation for future scalability and deployment

---

## 🛠️ Tech Stack

### Frontend
- **Flutter**
- Material UI
- Multi-language support (i18n)

### Backend
- **FastAPI (Python)**
- Google **Gemini API** (LLM for chatbot intelligence)

### Database & Auth
- **Supabase**
  - Secure authentication
  - Encrypted chat storage

---

## 🧠 System Architecture (High Level)
flowchart LR
    U[👨‍🌾 Farmer] --> F[📱 Flutter App]

    F -->|Login / Signup| SAuth[🔐 Supabase Auth]
    SAuth -->|JWT / Session| F

    F -->|Authenticated Chat Request| API[⚡ FastAPI Server]

    API -->|User Query + History| LLM[🤖 Gemini API]
    LLM -->|Generated Answer| API

    API -->|Store Chat Securely| DB[(🗄️ Supabase DB)]
    DB -->|Chat History| API

    API -->|Final Response| F
    F -->|Multilingual UI Output| U
------
## 🛠️ Setup Steps:

#### 1. Get Google Gemini API Key:
   - Go to https://makersuite.google.com/app/apikey
   - Create a new API key
   - Copy the API key

#### 2. Configure Backend:
   ```bash
   cd server
   cp .env.example .env
   ```
   
   Edit `.env` file and add your API key:
   ```
   GEMINI_API_KEY=your_google_gemini_api_key_here
   GEMINI_MODEL=gemini-1.5-flash
   ```

#### 3. Start the FastAPI Server:
   ```bash
   cd server
   uvicorn app_image_response:app --reload --host 127.0.0.1 --port 8000
   ```

#### 4. Test Server Health:
   Open http://127.0.0.1:8000/health in browser

#### 5. Run Flutter App:
   ```bash
   flutter run
   ```

### 📱 How to Use:

1. **Start Backend**: Run the FastAPI server first
2. **Start Flutter App**: Launch the app on your device/emulator
3. **Chat with KrishiMithra**: 
   - Type farming questions in English, Hindi, or Malayalam
   - Upload crop/plant images for analysis
   - Get AI-powered farming advice

### 🌟 Features Available:

#### Text Chat:
- Ask about crops, fertilizers, pest control, weather, irrigation
- Get responses in your preferred language
- Farming-specific AI that only answers agricultural questions

#### Image Analysis:
- Take photos of crops, plants, soil, pests
- Get instant AI analysis and recommendations
- Identify diseases, nutrient deficiencies, growth stages

#### App Features:
- Dark/Light theme toggle
- Language switching (English/Hindi/Malayalam)
- Clean, responsive Material Design 3 UI
- Offline capability for basic features

### 🔧 Troubleshooting:

#### If Chat Doesn't Work:
1. Check if FastAPI server is running on port 8000
2. Verify .env file has correct GEMINI_API_KEY
3. Check internet connection
4. For real device: Change baseUrl in ApiService to your computer's IP

#### For Real Device Testing:
1. Find your computer's IP address: `ipconfig` (Windows) or `ifconfig` (Mac/Linux)
2. Update ApiService.dart line 8: Replace `127.0.0.1` with your IP
3. Ensure firewall allows port 8000

### 📊 API Endpoints:

- `GET /health` - Health check
- `POST /generate` - Text message to AI
  ```json
  {"prompt": "How to grow tomatoes?"}
  ```
- `POST /generate` - Image + text analysis (multipart form)
  - `file`: Image file
  - `prompt`: Optional text prompt

### 🎯 Next Steps:

1. **Production Setup**: 
   - Deploy FastAPI to cloud (Heroku, AWS, Google Cloud)
   - Update Flutter baseUrl to production server
   - Add proper error handling and loading states

2. **Enhanced Features**:
   - User authentication
   - Chat history persistence
   - Weather integration
   - Crop calendar reminders
   - Market price updates

3. **Testing**:
   - Unit tests for API service
   - Widget tests for UI components
   - Integration tests for complete flow

Your KrishiMithra app is now ready to help farmers with AI-powered agricultural advice! 🌾

