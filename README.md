# Synpulse

## Demo Video

[https://youtu.be/NZhNiAgbBow](https://youtu.be/NZhNiAgbBowA)


## Guide to run the application

1. git clone [https://github.com/cyauai/synpulse_challenge.git](https://github.com/cyauai/synpulse_challenge.git) (In terminal)
2. install flutter
3. navigate to the directory that contains the synpulse_challenge file that cloned from git
4. flutter create --org com.cyauai synpulse_challenge (In terminal)
5. cd synpulse_challenge
6. flutter pub get
7. cd ios
8. pod install

### Running on Android (Real Device)

<aside>
💡 I do not test it on Android. There maybe some dependency issues or settings issues that makes the build failed

</aside>

1. navigate to the synpulse_challenge directory
2. flutter build apk (In terminal)
3. install the apk on an android phone

### Running on iOS (Real Device)

<aside>
💡 You can only run iOS app on a real device with the cable connection with the computer

</aside>

1. open the synpulse_challenge/iOS/Runner.xcworkspace with xcode
2. follow this to add the GoogleService-Info.plist (inside the synpulse_challenge directory) into the Xcode [https://stackoverflow.com/questions/31786362/how-to-add-plist-file-to-all-targets-in-xcode](https://stackoverflow.com/questions/31786362/how-to-add-plist-file-to-all-targets-in-xcode)
3. if there is already a GoogleService-Info.plist and the file is in red color, just remove it
4. Go to TARGETS > Signing & Capabilities > sign in a team
5. connect the computer with the iOS device
6. run and wait until the build finish

### Running on Emulator

<aside>
💡 Again, I recommend to run this on iOS emulator

</aside>

1. use any editor to open the synpulse_challenge file (I recommend vscode and install dart and flutter plugins)
2. select the emulator if you are using vscode
3. flutter run (In terminal) or open the main.dart file inside lib directory and click Run > run without debug if you are using vscode

## Document detail

### Project planning

To make an application that shows the detail of the stock, I prepared the following:

- Firebase → to save user data and handle authentication
- Alpha Vantage →
    - to retrieve the time series data of a particular stock,
    - to retrieve the quote data of a stock
    - to search a stock by ticker, common name or other terms
- polygon.io →
    - to retrieve the related news about tickers
    - to retrieve the url and logo of tickers

### Development process

Since I do not include any animation in the application, I simply draft the UI of each screen and based on the screen to create the corresponding data model.

<aside>
💡 Feel free to contact me if you cannot run the code

</aside>
