
![SwiftSensei](https://via.placeholder.com/150x30/ff6347/FFFFFF?text=SwiftSensei)
![Guiding you towards cleaner Swift code!](https://via.placeholder.com/350x20/32CD32/FFFFFF?text=Guiding%20you%20towards%20cleaner%20Swift%20code!)

SwiftSensei is a nimble Ruby script tailored for Swift developers. It brings to light common code quality issues, ensuring that your Swift code remains sharp and refined. From lingering "TODO" comments to potential pitfalls, SwiftSensei is here to guide you!

## ![Features](https://via.placeholder.com/100x20/4B0082/FFFFFF?text=Features):
1. **Comment Hunt**: Discovers "TODO" and "FIXME" annotations.
2. **Indentation Guru**: Identifies duplicate lines and inconsistent indentation.
3. **Naming Dojo**: Ensures variables adhere to the camelCase convention.
4. **Depth Detector**: Alerts when code nesting gets too deep.
5. **Size Scout**: Points out files that might be doing too much.
6. **Magic Number Mystic**: Finds unexplained numbers in your code.
7. **Safety Sentinel**: Advises against risky force unwraps.

## ![Requirements](https://via.placeholder.com/140x20/FFD700/000000?text=Requirements):
- Ruby
- 'colorize' gem: Get it with `gem install colorize`.

## ![Usage](https://via.placeholder.com/80x20/20B2AA/FFFFFF?text=Usage):
1. In the terminal, navigate to your Swift project directory.
2. Initiate SwiftSensei with:
   ```bash
   ruby path_to_swiftsensei.rb
   ```
3. Reflect upon SwiftSensei's insights and elevate your code.

## ![Xcode Integration](https://via.placeholder.com/180x20/8A2BE2/FFFFFF?text=Xcode%20Integration%20via%20Run%20Script):
To have SwiftSensei's wisdom right in Xcode, here's how:

1. Open your project in Xcode.
2. In the target settings, go to the "Build Phases" tab.
3. Tap the '+' and choose "New Run Script Phase".
4. In the script box, type:
   ```bash
   ruby path_to_swiftsensei.rb
   ```
5. Position this script above the "Compile Sources" phase.
6. When you build, SwiftSensei will share its findings as Xcode warnings.

## ![Contributing](https://via.placeholder.com/150x20/DC143C/FFFFFF?text=Contributing):
Share your wisdom! Enhancements and new checks are welcomed. Fork SwiftSensei and send in your pull requests.

## ![Note](https://via.placeholder.com/70x20/00008B/FFFFFF?text=Note):
SwiftSensei uses heuristics. Some findings might be subjective. Always meditate upon the output and follow your coding instincts.
