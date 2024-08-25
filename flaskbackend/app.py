from flask import Flask, request, jsonify
from flask_socketio import SocketIO, emit
import cv2
import mediapipe as mp
import numpy as np
import tensorflow as tf
from tensorflow.keras.models import load_model

app = Flask(__name__)
socketio = SocketIO(app)

# Load your pre-trained model
model = load_model('lstm-cnn.h5')

# Define the sign labels
actions = np.array(['salut', 'cv', 'oui_cv', 'ami', 'vrai', 'correct', 'au revoir', 'bien', 'mauvai', 'derien'])

def mediapipe_detection(image, model):
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB) 
    image.flags.writeable = False  
    results = model.process(image)  
    image.flags.writeable = True  
    image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)  
    return image, results

def extract_keypoints(results):
    pose = np.array([[res.x, res.y, res.z, res.visibility] for res in results.pose_landmarks.landmark]).flatten() if results.pose_landmarks else np.zeros(33*4)
    face = np.array([[res.x, res.y, res.z] for res in results.face_landmarks.landmark]).flatten() if results.face_landmarks else np.zeros(468*3)
    lh = np.array([[res.x, res.y, res.z] for res in results.left_hand_landmarks.landmark]).flatten() if results.left_hand_landmarks else np.zeros(21*3)
    rh = np.array([[res.x, res.y, res.z] for res in results.right_hand_landmarks.landmark]).flatten() if results.right_hand_landmarks else np.zeros(21*3)
    return np.concatenate([pose, face, lh, rh])

def extract_frames_from_video(video_path):
    cap = cv2.VideoCapture(video_path)
    sequence = []

    with mp.solutions.holistic.Holistic(min_detection_confidence=0.5, min_tracking_confidence=0.5) as holistic:
        while cap.isOpened():
            ret, frame = cap.read()
            if not ret:
                break
            
            # Process the frame
            image, results = mediapipe_detection(frame, holistic)
            
            # Extract keypoints
            keypoints = extract_keypoints(results)
            sequence.append(keypoints)
        
        cap.release()
        cv2.destroyAllWindows()

    return np.array(sequence)  # Return the sequence of keypoints

@app.route('/upload-video', methods=['POST'])
def upload_video():
    try:
        file = request.files['video']
        video_path = "temp_video.mp4"
        file.save(video_path)

        keypoints = extract_frames_from_video(video_path)
        
        # Ensure that the sequence is the correct length
        keypoints_padded = np.zeros((30, 1662))  # 30 frames, 1662 keypoints
        keypoints_padded[-min(30, keypoints.shape[0]):] = keypoints[-min(30, keypoints.shape[0]):]

        prediction = model.predict(np.expand_dims(keypoints_padded, axis=0))[0]
        predicted_index = np.argmax(prediction)
        sign_name = actions[predicted_index]

        # Emit the prediction to the connected client via Socket.IO
        socketio.emit('prediction', {'prediction': sign_name})
        
        return jsonify({"status": "success", "prediction": sign_name})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=5000)
