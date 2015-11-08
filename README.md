### WIP
# Former
![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat) [![Language](https://img.shields.io/badge/swift2-compatible-4BC51D.svg?style=flat)](https://developer.apple.com/swift)
<!-- [![CocoaPods Shield](https://img.shields.io/cocoapods/v/FloatingActionSheetController.svg)](https://cocoapods.org/pods/Former) -->
<!-- [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) -->
[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/ra1028/Former/master/LICENSE)

__Former__ is a fully customizable Swift2 library for easy creating UITableView based form.

## Requirements  
- Xcode 7+
- iOS 8.0+  
- Swift 2.0+

To be supported: iOS 7.0+

## Usage

### example
```swift
/* You can also use your own ViewController that implemented TableView.
*  See FormViewController.
*/
final class YourViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let textRow = LabelRowFormer<FormLabelCell>() {
                // Cell setup
            }.configure {
                // RowFormer setup
            }.onSelected {
                // Selection handler
        }

        let inlineDatePickerRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
                // Cell setup
            }.configure {
                // Row Former setup
            }.onValueChanged {
                // Value change handler
            }.inlineCellSetup {
                // DatePicker cell setup
        }

        let header = LabelViewFormer<FormLabelHeaderView>() {
                // Header view setup
            }.configure {
                // ViewFormer setup
        }

        let section = SectionFormer(rowFormers: [textRow, inlineDatePickerRow])
            .set(headerViewFormer: header)

        former.add(sectionFormers: [section])
            .onScroll {
                // TableView scroll handler
            }.onCellSelected {
                // Cell selected handler
        }
    }
}
```

## License
Former is available under the MIT license. See the LICENSE file for more info.
