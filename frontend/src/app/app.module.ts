import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { AppComponent } from './app.component';
import { SentimentAnalyzerComponent } from './sentiment-analyzer/sentiment-analyzer.component';
import { FaceDetectionComponent } from './face-detection/face-detection.component';

@NgModule({
  declarations: [
    AppComponent,
    SentimentAnalyzerComponent,
    FaceDetectionComponent,

  ],
  imports: [
    BrowserModule,
    FormsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
