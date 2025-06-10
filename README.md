# Flutter Project Setup

Follow these steps to set up and run the Flutter project.

## Steps

1. **Install Android Studio**

   Download and install Android Studio from the official website:  
   [https://developer.android.com/studio](https://developer.android.com/studio)

2. **Create an Android Virtual Device (AVD)**

   - Open Android Studio
   - Go to **Tools > AVD Manager**
   - Click **Create Virtual Device**
   - Choose a device and system image
   - Finish the setup and start the emulator

3. **Install FVM (Flutter Version Manager)**

   FVM helps manage Flutter versions easily.

   ```
   dart pub global activate fvm
    ```
4. **Install Flutter 3.24.1 using FVM**

    ```
    fvm install 3.24.1
    fvm use 3.24.1
    ```
5. **Get Flutter packages**
Run this command to fetch all dependencies:
    ```
    flutter pub get
    ```

6. **Run the Flutter project**
Run your project on the emulator or connected device:

    ```
    flutter run
    ```
