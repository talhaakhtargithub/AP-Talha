import { Component } from '@angular/core';
import axios from 'axios';

@Component({
  selector: 'app-face-detection',
  templateUrl: './face-detection.component.html',
  styleUrls: ['./face-detection.component.css']
})
export class FaceDetectionComponent {
  selectedFile: File | null = null;
  message: string = '';
  imageURL: string | ArrayBuffer | null = null;

  // Function to handle file selection and preview
  onFileSelected(event: any) {
    this.selectedFile = event.target.files[0];

    if (this.selectedFile) {
      const reader = new FileReader();
      reader.onload = () => this.imageURL = reader.result;
      reader.readAsDataURL(this.selectedFile);
    }
  }

  // Function to send file to the backend for face detection
  async detectFace() {
    if (this.selectedFile) {
      const formData = new FormData();
      formData.append('file', this.selectedFile, this.selectedFile.name);

      try {
        const response = await axios.post('http://127.0.0.1:8000/upload-face/', formData, {
          headers: { 'Content-Type': 'multipart/form-data' }
        });

        // Display result from the backend
        this.message = response.data.message || response.data.error;
      } catch (error) {
        console.error('Error detecting face:', error);
        this.message = 'Error detecting face. Please try again.';
      }
    } else {
      this.message = 'Please select an image file first.';
    }
  }
}
