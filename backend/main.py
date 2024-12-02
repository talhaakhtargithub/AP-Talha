from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from transformers import pipeline
from io import BytesIO
import cv2
import numpy as np

# Initialize FastAPI app
app = FastAPI()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Replace "*" with specific domains for production
    allow_credentials=True,
    allow_methods=["*"],  # Allows all HTTP methods
    allow_headers=["*"],  # Allows all HTTP headers
)

# Load the pre-trained sentiment analysis model
sentiment_analyzer = pipeline('sentiment-analysis', model='distilbert-base-uncased-finetuned-sst-2-english')

# Define a face detection function using OpenCV's Haar Cascade
def detect_face(image_bytes: BytesIO):
    try:
        # Convert the image bytes to a NumPy array
        np_array = np.frombuffer(image_bytes.read(), np.uint8)
        img = cv2.imdecode(np_array, cv2.IMREAD_COLOR)

        # Load the pre-trained Haar Cascade for face detection
        face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')
        
        # Convert the image to grayscale
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        
        # Detect faces
        faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5, minSize=(30, 30))

        # Check if faces are detected
        if len(faces) > 0:
            return {"message": f"Found {len(faces)-1} face(s) in the image."}
        else:
            return {"message": "No faces found in the image."}
    except Exception as e:
        return {"error": f"An error occurred while processing the image: {str(e)}"}

# Create a Pydantic model for the input text
class TextInput(BaseModel):
    text: str

# Define the POST endpoint for sentiment analysis
@app.post("/predict/")
async def predict_sentiment(input: TextInput):
    # Run sentiment analysis on the provided text
    result = sentiment_analyzer(input.text)

    # Return the sentiment label (positive/negative) and the confidence score
    return {"sentiment": result[0]['label'], "confidence": result[0]['score']}

# Define a new POST endpoint for uploading an image
@app.post("/upload-face/")
async def upload_face(file: UploadFile = File(...)):
    # Read the file contents into memory
    image_bytes = await file.read()
    
    # Use the face detection function (this now uses OpenCV for face detection)
    result = detect_face(BytesIO(image_bytes))
    
    return result

# Define a simple root endpoint for testing
@app.get("/")
async def read_root():
    return {"message": "Welcome to the Hugging Face API!"}
