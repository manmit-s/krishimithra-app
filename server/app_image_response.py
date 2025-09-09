# app.py
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from dotenv import load_dotenv
from fastapi.concurrency import run_in_threadpool
import google.generativeai as genai
import os
from fastapi import File, UploadFile
from fastapi.responses import JSONResponse
import base64

# 1) Load environment variables from .env
load_dotenv()

API_KEY = os.getenv("GEMINI_API_KEY")
MODEL_NAME = os.getenv("GEMINI_MODEL", "gemini-1.5-flash")

if not API_KEY:
    # Fail fast if key missing — saves head-scratching later
    raise RuntimeError(
        "GEMINI_API_KEY not found. Put it in .env like: GEMINI_API_KEY=your_key_here"
    )

# 2) Configure Gemini SDK with your key
genai.configure(api_key=API_KEY)

# 3) Pydantic model: defines the JSON shape we accept from the client
class PromptIn(BaseModel):
    prompt: str

# 4) Optional output schema (handy if you later add usage, latency, etc.)
class OutputOut(BaseModel):
    output: str

# 5) Create FastAPI app
app = FastAPI(title="Gemini Relay API", version="1.0")

# 6) CORS middleware — lets your Flutter app call this server in dev
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],         # in production, list specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 7) Health check endpoint — easy ping for “is server alive?”
@app.get("/health")
def health():
    return {"status": "ok", "model": MODEL_NAME}

# 8) Main endpoints: separate text and image handling

@app.post("/generate", response_model=OutputOut)
async def generate_text(body: PromptIn):
    """Generate farming advice from text prompt"""
    try:
        prompt = body.prompt.strip()
        if not prompt:
            raise HTTPException(status_code=400, detail="Prompt is required.")

        model = genai.GenerativeModel(MODEL_NAME)

        # System prompt for farming advisor
        system_prompt = """You are KrishiMithra, a Digital Krishi Advisor for farmers. Your role is to provide helpful, accurate, and practical advice about farming, agriculture, crops, irrigation, soil management, pest control, fertilizers, weather-related farming issues, livestock, and other agricultural topics.

Guidelines:
- Only answer questions related to farming, agriculture, crops, and rural development
- Provide practical, actionable advice that farmers can implement
- If asked about non-farming topics, politely redirect to agricultural matters
- Be supportive and understanding of farming challenges
- Use simple, clear language that farmers can easily understand
- Try to answer as short as possible

Always start your response in a helpful, encouraging tone."""

        full_prompt = f"{system_prompt}\n\nUser Query: {prompt}"
        
        # Run Gemini text generation
        response = await run_in_threadpool(model.generate_content, full_prompt)

        output_text = getattr(response, "text", None)
        if not output_text:
            raise RuntimeError("No text returned from Gemini.")

        return {"output": output_text}

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Generation failed: {str(e)}")

@app.post("/generate-image", response_model=OutputOut)
async def generate_with_image(file: UploadFile = File(...), prompt: str = ""):
    """Generate farming advice from image with optional text prompt"""
    try:
        model = genai.GenerativeModel(MODEL_NAME)

        # System prompt for farming advisor
        system_prompt = """You are KrishiMithra, a Digital Krishi Advisor for farmers. Your role is to provide helpful, accurate, and practical advice about farming, agriculture, crops, irrigation, soil management, pest control, fertilizers, weather-related farming issues, livestock, and other agricultural topics.

Guidelines:
- Only answer questions related to farming, agriculture, crops, and rural development
- Provide practical, actionable advice that farmers can implement
- If asked about non-farming topics, politely redirect to agricultural matters
- Be supportive and understanding of farming challenges
- Use simple, clear language that farmers can easily understand
- When analyzing images, focus on identifying crops, diseases, pests, soil conditions, or farming-related issues
- Try to answer as short as possible

Always start your response in a helpful, encouraging tone."""

        inputs = []
        
        # Add system prompt and user query
        if prompt.strip():
            full_prompt = f"{system_prompt}\n\nUser Query: {prompt}"
            inputs.append(full_prompt)
        else:
            inputs.append(f"{system_prompt}\n\nPlease analyze this farming-related image and provide relevant agricultural advice.")

        # Add image
        img_bytes = await file.read()
        inputs.append({"mime_type": file.content_type, "data": img_bytes})

        # Run Gemini multimodal generation
        response = await run_in_threadpool(model.generate_content, inputs)

        output_text = getattr(response, "text", None)
        if not output_text:
            raise RuntimeError("No text returned from Gemini.")

        return {"output": output_text}

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Generation failed: {str(e)}")


# 9) Root — optional friendly message
@app.get("/")
def root():
    return {"message": "Gemini Relay API. POST /generate with { 'prompt': '...'}"}
