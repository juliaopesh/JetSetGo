# JetSetGo


https://github.com/user-attachments/assets/ae922c79-5b14-4679-8393-3a7f15d8b6bc



## Overview

Travel has become an essential part of life for many people, whether for business, leisure, or education. However, keeping track of your items, documents, weather, and schedule during your trips can be stressful. A small misstep, forgotten detail, or improper preparation can add unnecessary stress to your travel plans.

This project aims to alleviate these challenges by offering a comprehensive travel companion app designed to simplify trip organization. The app provides tools for travelers to keep track of their important information and offers **AI-powered travel advice** to enhance the travel experience. With features such as personalized destination suggestions, custom packing lists, and real-time weather forecasts, travelers can stay organized and make the most out of their journeys.

While this app is built to streamline travel organization, it's not meant to replace services that book flights or accommodations. Instead, the app integrates with those services by allowing users to upload documents (such as booking confirmations) for easy tracking during their travels.

## Features

- **Travel Organization**: Easily upload and keep track of important documents, travel schedules, and packing lists.
- **AI-Powered Suggestions**: The app provides personalized travel advice, including destination suggestions and custom packing lists based on your location and time of year.
- **Real-Time Weather Forecasts**: Get live weather updates for your travel destination with the OpenWeather API.
- **Seamless Integration**: Upload travel documents (e.g., flight bookings, hotel reservations) to the app for easy access and management.
- **Cross-Platform Support**: The app is built using **Flutter**, ensuring compatibility across iOS and Android devices.

## Technologies Used

- **Flutter**: For building the cross-platform mobile app.
- **Firebase Authentication**: For user login and authentication.
- **Cloud Firestore**: For real-time, structured data storage.
- **Firebase Storage**: For uploading and retrieving travel documents.
- **OpenWeather API**: For live destination weather forecasts.
- **Gemini API (Google AI)**: For generating personalized packing and trip suggestions based on user preferences.

Make sure you have a Flutter environment set up on your machine. You can check the official [Flutter installation guide](https://flutter.dev/docs/get-started/install) for help with setup.

## Usage

- **Sign up/Login**: Use Firebase Authentication to create an account or log in.
- **Upload Documents**: Upload travel-related documents (e.g., flight tickets, hotel bookings) using Firebase Storage.
- **View Weather**: Get real-time weather updates for your travel destination through the OpenWeather API.
- **Get AI Suggestions**: The app will generate personalized travel advice based on your preferences, including destination recommendations and custom packing lists.

## Acknowledgments
- Developed as a collaborative project for the CIS 4030: Mobile Computing
- **OpenWeather API**: For providing weather data.
- **Google Gemini AI**: For helping generate personalized travel suggestions.
- **Firebase**: For authentication, data storage, and file management.
