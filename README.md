# NDHUD


**NDHUD** is a loadind HUD for iOS.

![sample](Screenshot/flat.gif)
![sample](Screenshot/native.gif)


## Requirements

- Runs on iOS 9.0 and later
- Requires Swift 4.0  and ARC.

## Installation

NDHUD is available on CocoaPods.

CocoaPods:

```ruby
pod "NDHUD"
```
## USAGE


```swift
NDHUD.show()
NDHUD.hide()
```

If you want to use the custom option, you can do:

```swift
NDHUD.color = UIColor.red
NDHUD.lineWidth = 2.0
...
    
```

