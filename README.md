# Card-IO Flutter App with Docker

Card-io is a machine learning-powered Flutter application that utilizes a two-model pipeline. The first model predicts heart rate and body temperature based on inputs such as age, gender, height, and weight. The second model, taking the predicted values along with additional parameters like steps count (from a pedometer), distance traveled, and basic user information, estimates the calories burned. This app leverages advanced regression techniques to deliver real-time health insights.

## Prerequisites

Before using the Docker container, ensure you have the following installed:

- [Docker](https://www.docker.com/get-started)
- [Flutter](https://flutter.dev/docs/get-started/install) (Optional: if you want to build the app locally)
- A Docker Hub account (Optional: if you want to push/pull images)

## Docker Setup

This project includes a pre-built Docker image for **Card-IO**. You can run the app directly from the Docker container or build it yourself using the provided Dockerfile.

### 1. Clone the Repository

First, clone the repository to your local machine:

```bash
git clone https://github.com/yourusername/card-io.git
cd card-io
```

# Running the Docker to Build the Flutter App

This guide will help you pull the Docker image and run it, which will automatically build the Flutter app in the `/build` folder.

## Instructions

### 1. Pull the Docker Image

```bash
docker pull vigneshraiml/card-io:latest
```

### 2. Run the Docker Container

```bash
docker run -v $(pwd)/build:/app/build -d --name card-io-container vigneshraiml/card-io:latest
```

### 3. Check the Build Output

```bash
ls Builded_APK
```

# You can check the built APK file in the folder.
