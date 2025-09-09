import requests
import json

def test_api():
    base_url = "http://127.0.0.1:8000"
    
    print("🧪 Testing KrishiMithra API...")
    
    # Test health check
    try:
        response = requests.get(f"{base_url}/health")
        print(f"✅ Health check: {response.status_code} - {response.json()}")
    except Exception as e:
        print(f"❌ Health check failed: {e}")
        return
    
    # Test text generation
    try:
        data = {"prompt": "How to grow tomatoes?"}
        response = requests.post(
            f"{base_url}/generate",
            headers={"Content-Type": "application/json"},
            json=data
        )
        print(f"📝 Text generation: {response.status_code}")
        if response.status_code == 200:
            result = response.json()
            print(f"Response: {result['output'][:100]}...")
        else:
            print(f"Error: {response.text}")
    except Exception as e:
        print(f"❌ Text generation failed: {e}")

if __name__ == "__main__":
    test_api()
