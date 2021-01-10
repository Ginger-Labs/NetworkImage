# NetworkImage
[![CI](https://github.com/gonzalezreal/NetworkImage/workflows/CI/badge.svg)](https://github.com/gonzalezreal/NetworkImage/actions?query=workflow%3ACI)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fgonzalezreal%2FNetworkImage%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/gonzalezreal/NetworkImage)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fgonzalezreal%2FNetworkImage%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/gonzalezreal/NetworkImage)
[![contact: @gonzalezreal](https://img.shields.io/badge/contact-@gonzalezreal-blue.svg?style=flat)](https://twitter.com/gonzalezreal)

NetworkImage is a Swift µpackage that provides image downloading, caching, and displaying for your SwiftUI apps. It leverages the foundation URLCache, providing persistent and in-memory caches.

You can explore all the capabilities of this package in the [companion playground](/Playgrounds/NetworkImage.playground).

* [Supported Platforms](#supported-platforms)
* [Displaying Network Images](#displaying-network-images)
* [Customizing Network Images](#customizing-network-images)
* [Creating Custom Image Styles](#creating-custom-image-styles)
* [Using the Shared ImageDownloader](#using-the-shared-imageDownloader)
* [Installation](#installation)
* [Other Libraries](#other-libraries)

## Supported Platforms

You can use the `NetworkImage` SwiftUI view in the following platforms:

* macOS 11.0+
* iOS 14.0+
* tvOS 14.0+
* watchOS 7.0+

The `ImageDownloader` is available in: 

* macOS 10.15+
* iOS 13.0+
* tvOS 13.0+
* watchOS 6.0+

## Displaying Network Images
You can use a `NetworkImage` view to display an image from a given URL. The download happens asynchronously, and the resulting image is cached both in disk and memory.

```swift
struct ContentView: View {
    var body: some View {
        NetworkImage(url: URL(string: "https://picsum.photos/id/237/300/200"))
            .frame(width: 300, height: 200)
    }
}
```

By default, remote images are resizable and fill the available space while maintaining the aspect ratio.

## Customizing Network Images
You can customize a network image's appearance by using a network image style. The default image style is an instance of `ResizableNetworkImageStyle` configured to `fill` the available space. To set a specific style for all network images within a view, you can use the `networkImageStyle(_:)` modifier.

```swift
struct ContentView: View {
    var body: some View {
        HStack {
            NetworkImage(url: URL(string: "https://picsum.photos/id/1025/300/200"))
                .frame(width: 200, height: 200)
            NetworkImage(url: URL(string: "https://picsum.photos/id/237/300/200"))
                .frame(width: 200, height: 200)
        }
        .networkImageStyle(
            ResizableNetworkImageStyle(
                backgroundColor: .yellow,
                contentMode: .fit
            )
        )
    }
}
```

## Creating Custom Image Styles
To add a custom appearance, create a type that conforms to the `NetworkImageStyle` protocol. You can customize a network image's appearance in all of its different states: loading, displaying an image or failed.

```swift
struct RoundedImageStyle: NetworkImageStyle {
    var width: CGFloat?
    var height: CGFloat?

    func makeBody(state: NetworkImageState) -> some View {
        ZStack {
            Color(.secondarySystemBackground)

            switch state {
            case .loading:
                EmptyView()
            case let .image(image, _):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failed:
                Image(systemName: "photo")
                    .foregroundColor(Color(.systemFill))
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}
```

Then set the custom style for all network images within a view, using the `networkImageStyle(_:)` modifier:

```swift
struct ContentView: View {
    var body: some View {
        HStack {
            NetworkImage(url: URL(string: "https://picsum.photos/id/1025/300/200"))
            NetworkImage(url: URL(string: "https://picsum.photos/id/237/300/200"))
        }
        .networkImageStyle(
            RoundedImageStyle(width: 200, height: 200)
        )
    }
}
```

## Using the Shared ImageDownloader
For other use cases outside the scope of SwiftUI, you can download images directly using the shared `ImageDownloader`. Here you can see an example of a view controller that downloads an image and applies a transformation to it.
  
  ```swift
  class MyViewController: UIViewController {
      private lazy var imageView = UIImageView()
      private var cancellables: Set<AnyCancellable> = []

      override func loadView() {
          let view = UIView()
          view.backgroundColor = .systemBackground

          imageView.translatesAutoresizingMaskIntoConstraints = false
          imageView.backgroundColor = .secondarySystemBackground
          view.addSubview(imageView)

          NSLayoutConstraint.activate([
              imageView.widthAnchor.constraint(equalToConstant: 300),
              imageView.heightAnchor.constraint(equalToConstant: 200),
              imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
              imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
          ])

          self.view = view
      }

      override func viewDidLoad() {
          super.viewDidLoad()

          ImageDownloader.shared.image(for: URL(string: "https://picsum.photos/id/237/300/200")!)
              .map { image in
                  // tint the image with a yellow color
                  UIGraphicsImageRenderer(size: image.size).image { _ in
                      image.draw(at: .zero)
                      UIColor.systemYellow.setFill()
                      UIRectFillUsingBlendMode(CGRect(origin: .zero, size: image.size), .multiply)
                  }
              }
              .replaceError(with: UIImage(systemName: "film")!)
              .receive(on: DispatchQueue.main)
              .sink(receiveValue: { [imageView] image in
                  imageView.image = image
              })
              .store(in: &cancellables)
      }
  }
```

## Installation
You can add NetworkImage to an Xcode project by adding it as a package dependency.
1. From the **File** menu, select **Swift Packages › Add Package Dependency…**
1. Enter `https://github.com/gonzalezreal/NetworkImage` into the package repository URL text field
1. Link **NetworkImage** to your application target

## Other Libraries
* [AsyncImage](https://github.com/V8tr/AsyncImage)
