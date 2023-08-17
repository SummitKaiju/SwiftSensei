
## **SwiftSensei**
**Guiding you towards cleaner Swift code!**

---

SwiftSensei is a nimble Ruby script tailored for Swift developers. It brings to light common code quality issues, ensuring that your Swift code remains sharp and refined. From lingering "TODO" comments to potential pitfalls, SwiftSensei is here to guide you!

---

### **Features:**

- **Comment Hunt**: Discovers "TODO" and "FIXME" annotations.
- **Indentation Guru**: Identifies duplicate lines and inconsistent indentation.
- **Naming Dojo**: Ensures variables adhere to the camelCase convention.
- **Depth Detector**: Alerts when code nesting gets too deep.
- **Size Scout**: Points out files that might be doing too much.
- **Magic Number Mystic**: Finds unexplained numbers in your code.
- **Safety Sentinel**: Advises against risky force unwraps.

---

### **Requirements:**
- Ruby
- 'colorize' gem: Get it with `gem install colorize`.

---

### **Usage:**
1. In the terminal, navigate to your Swift project directory.
2. Initiate SwiftSensei with:
   ```bash
   ruby path_to_swiftsensei.rb
   ```
3. Reflect upon SwiftSensei's insights and elevate your code.

---

### **Xcode Integration via Run Script:**
To have SwiftSensei's wisdom right in Xcode, follow these steps:

1. Open your project in Xcode.
2. In the target settings, go to the "Build Phases" tab.
3. Tap the '+' and choose "New Run Script Phase".
4. In the script box, type:
   ```bash
   ruby path_to_swiftsensei.rb
   ```
5. Position this script above the "Compile Sources" phase.
6. When you build, SwiftSensei will share its findings as Xcode warnings.

---

### **Contributing:**
Share your wisdom! Enhancements and new checks are welcomed. Fork SwiftSensei and send in your pull requests.

---

### **Note:**
SwiftSensei uses heuristics. Some findings might be subjective. Always meditate upon the output and follow your coding instincts.

