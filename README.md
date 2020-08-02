### Import the framework

First thing is to import the framework. See the Installation instructions on how to add the framework to your project.

```swift
import SimplePermissions
```

### Usage

```swift
 if Permissions.status(of: .microphone) == .notDetermined {
   Permissions.request(for: .microphone) { status in
    print("Status of microphone permission: \(status)")
   }
 }
```

### CocoaPods

Check out [Get Started](http://cocoapods.org/) tab on [cocoapods.org](http://cocoapods.org/).

To use SimplePermissions in your project add the following 'Podfile' to your project

```
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '13.0'

use_frameworks!

pod 'SimplePermissions', '~> 0.1.1'
```

Then run:

```
pod install
```

## License

SimplePermissions is licensed under the MIT License.
