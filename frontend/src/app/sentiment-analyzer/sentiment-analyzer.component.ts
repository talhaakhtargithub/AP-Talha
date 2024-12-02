import { Component } from '@angular/core';
import axios from 'axios';

@Component({
  selector: 'app-sentiment-analyzer',
  templateUrl: './sentiment-analyzer.component.html',
  styleUrls: ['./sentiment-analyzer.component.css']
})
export class SentimentAnalyzerComponent {
  inputText: string = '';
  sentiment: string = '';
  confidence: number = 0;

  // Function to send request to backend
  async analyzeSentiment() {
    try {
      const response = await axios.post('http://127.0.0.1:8000/predict/', {
        text: this.inputText
      });
      this.sentiment = response.data.sentiment;
      this.confidence = response.data.confidence;
    } catch (error) {
      console.error('Error analyzing sentiment:', error);
    }
  }
}
