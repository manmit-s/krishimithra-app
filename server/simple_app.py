# Simple FastAPI test server
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from dotenv import load_dotenv
import google.generativeai as genai
import os

# Load environment variables
load_dotenv()

app = FastAPI(title="KrishiMithra Simple API", description="Text-only farming assistant")

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Configure Google Gemini
api_key = os.getenv("GEMINI_API_KEY")
if not api_key:
    print("Warning: GEMINI_API_KEY not found. Server will run in mock mode.")
    MOCK_MODE = True
else:
    genai.configure(api_key=api_key)
    model = genai.GenerativeModel('gemini-1.5-flash')
    MOCK_MODE = False

class PromptRequest(BaseModel):
    prompt: str

class ApiResponse(BaseModel):
    output: str

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy", 
        "service": "KrishiMithra Simple API",
        "mode": "mock" if MOCK_MODE else "gemini"
    }

@app.post("/generate", response_model=ApiResponse)
async def generate_text(request: PromptRequest):
    """Generate farming advice from text prompt"""
    try:
        if MOCK_MODE:
            # Mock response for testing
            return {"output": f"🌾 KrishiMithra Mock Response: Thank you for asking about '{request.prompt}'. This is a test response since Gemini API key is not configured. In production, I would provide detailed farming advice based on your question."}
        
        # System prompt for farming advisor
        system_prompt = """You are KrishiMithra, a Digital Krishi Advisor for farmers. Your role is to provide helpful, accurate, and practical advice about farming, agriculture, crops, irrigation, soil management, pest control, fertilizers, weather-related farming issues, livestock, and other agricultural topics.

Guidelines:
- Only answer questions related to farming, agriculture, crops, and rural development
- Provide practical, actionable advice that farmers can implement
- If asked about non-farming topics, politely redirect to agricultural matters
- Be supportive and understanding of farming challenges
- Use simple, clear language that farmers can easily understand

Always start your response in a helpful, encouraging tone."""
        
        full_prompt = f"{system_prompt}\n\nUser Query: {request.prompt}"
        
        # Call Gemini API
        response = model.generate_content(full_prompt)
        
        if not response.text:
            raise HTTPException(status_code=500, detail="No response from AI model")
        
        return {"output": response.text}
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Generation failed: {str(e)}")

@app.get("/")
async def root():
    return {"message": "KrishiMithra Simple API. POST /generate with {'prompt': 'your question'}"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)
