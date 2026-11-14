# Metro City — Open World Android Prototype

This is a starter Godot 4.3 project for a third-person, mobile-friendly city exploration game.

## Included in this first prototype
- Procedurally generated city blocks and roads
- Third-person player and follow camera
- Keyboard controls for desktop testing
- Basic on-screen touch movement, RUN and JUMP buttons
- Mobile-friendly Godot Compatibility renderer
- GitHub Actions workflow to export an Android APK

## Important
This is a playable **prototype foundation**, not a finished AAA game. The city uses procedural placeholder geometry. Later updates can add detailed buildings, traffic, cars, missions, NPCs, audio, save data and improved character animations.

## Test on PC
1. Install Godot 4.3 Standard.
2. Open `project.godot`.
3. Press F6/F5 to run the project.

## Build APK through GitHub
1. Create a new GitHub repository, for example `metro-city-open-world`.
2. Upload all files and folders from this project to the repository root.
3. Open the repository's **Actions** tab.
4. Select **Build Android APK** and press **Run workflow** (or push to `main`).
5. When the workflow completes, open the run and download the `MetroCity-Android-APK` artifact.

## Android export setup
The workflow uses the `barichello/godot-ci:4.3` container. Godot Android export templates and Android build tools must be available in the container for the export step. If the workflow reports that the Android template is missing, install the matching Godot 4.3 Android export templates in the CI image or switch to a maintained Godot CI image that bundles them.

## Controls
- Desktop: WASD / arrow keys to move, mouse to rotate camera, Space is not mapped yet.
- Android: use the lower-left touch pad, RUN and JUMP buttons.

## Package
`com.openworld.metrocity`
