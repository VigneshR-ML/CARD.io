FROM debian:latest AS build-env

RUN apt-get update \
    && apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3 openjdk-17-jdk \
    && apt-get clean

RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN wget https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip \
    && mkdir -p /android-sdk/cmdline-tools \
    && unzip commandlinetools-linux-7583922_latest.zip -d /android-sdk/cmdline-tools \
    && rm commandlinetools-linux-7583922_latest.zip

RUN mv /android-sdk/cmdline-tools/cmdline-tools /android-sdk/cmdline-tools/latest

ENV ANDROID_HOME="/android-sdk"
ENV PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

RUN sdkmanager --list

RUN sdkmanager --update

RUN yes | sdkmanager --licenses

RUN sdkmanager "platform-tools" "build-tools;33.0.0" "platforms;android-33"

WORKDIR /app

COPY . .

RUN flutter pub get

RUN flutter build apk

RUN mkdir -p /Builded_APK

RUN cp /app/build/app/outputs/flutter-apk/app-release.apk /Builded_APK/

CMD ["echo", "APK build completed. Check the /Builded_APK/ folder."]
