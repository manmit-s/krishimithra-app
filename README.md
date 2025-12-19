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


