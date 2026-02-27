#Gropper
Gropper is designed for those who find themselves frequently on either end of the phrase "Im heading out - need anything?". 
Let selected phone contacts know where you're heading and that you can pick up items they may need or request one of your contacts to pick up stuff you need from a specific location.
With a simple, easily navigable, dashboard you can see all of the trips you're apart of and have a detailed organized view of each trip. You also have the power to accept/deny other's requests and cancel pending requests if you change your mind before the trip is approved/denied. 

Production-ready iOS application built with SwiftUI and a custom backend infrastructure.
Implements secure phone-number authentication, real-time push notifications, and scalable device session management.

##Overview
Gropper is a full-stack iOS application designed and built from scratch. The app uses phone-number-based OTP authentication, integrates with push notifications through Apple Push Notification Service (APNs), and runs on a cloud-hosted backend with persistent database storage.
This project demonstrates end-to-end product development, including:
  - Mobile app architecture
  - Backend API design
  - Authentication flows
  - Push notification lifecycle management
  - Cloud deployment
  - Privacy compliance for App Store submission

##Core Components
###iOS Frontend
Built with SwiftUI
MVVM architecture
Centralized state management
Multi-device session handling
APNs registration and token forwarding
###Backend
Node.js / Express REST API
MySQL for persistent storage
OTP verification flow
Device token registration and deletion
Multi-device login support
