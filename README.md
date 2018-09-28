# ANZSingleImageViewer

[![Version](https://img.shields.io/cocoapods/v/ANZSingleImageViewer.svg?style=flat)](https://cocoapods.org/pods/ANZSingleImageViewer)
[![License](https://img.shields.io/cocoapods/l/ANZSingleImageViewer.svg?style=flat)](https://cocoapods.org/pods/ANZSingleImageViewer)
[![Platform](https://img.shields.io/cocoapods/p/ANZSingleImageViewer.svg?style=flat)](https://cocoapods.org/pods/ANZSingleImageViewer)

![ANZSingleImageViewer](https://github.com/anzfactory/ANZSingleImageViewer/blob/master/ScreenShots/screenshot.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Xcode 10+
- Swift 4.2+
- iOS 8.0+

## Installation

ANZSingleImageViewer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ANZSingleImageViewer'
```

## Sample Usage

```swift
class ViewController: UIViewController {

    private func openImage(_ image: UIImage) {

        ANZSingleImageViewer.showImage(image, toParent: self)
    }
}
```

### Zoom Transition

```swift
class ViewController: ANZSingleImageViewerSourceTransitionDelegate {

    func viewerTargetImageView() -> UIImageView? {
        
        return targetImageView
    }
}
```

## Author

anzfactory, anz.factory@gmail.com

## License

ANZSingleImageViewer is available under the MIT license. See the LICENSE file for more info.

## CREDIT

[Unsplash](https://unsplash.com/)

- [Kelly Sikkema](https://unsplash.com/@kellysikkema)
- [Rich Hay](https://unsplash.com/@richexploration)
- [Vidar Nordli-Mathisen](https://unsplash.com/@vidarnm)
- [Toshi](https://unsplash.com/@toshidog)