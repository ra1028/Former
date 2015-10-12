### WIP
# Former
<p align="center">
<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift2-compatible-4BC51D.svg?style=flat" alt="Swift 2 compatible" /></a>
<a href="https://raw.githubusercontent.com/ra1028/Former/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

__Former__ is a fully customizable Swift2 library for easy creating UITableView based form.

## Feature
- Can easy handling and receive type-safe value by closure.
- You need __NOT__ to override architecture such as UIViewController or UITableViewCell.
- Load cell from nib is fully supported.
- Can contain normal tableview cell into form. See the Demo app.

## Requirements  
- iOS 8.0+  
- Swift 2.0  

To be support iOS7.0+

## Usage
```swift
import Former
class YourViewController : UIViewController {

    @IBOutlet private weak var tableView = UITableView(frame: CGRect.zero, style: .Grouped)

    public lazy var former: Former = { [unowned self] in
        return Former(tableView: self.tableView)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let textRow = TextRowFormer<FormTextCell>() {
            // Cell setup
        }

        let inlineDatePickerRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>(
            inlineCellSetup: {
              // Datepicker cell setup
            }) {
              // Cell setup
        }

        let header = TextViewFormer<FormTextHeaderView>() {
            // Header view setup
        }

        let section = SectionFormer(rowFormers: [textRow, inlineDatePickerRow])
            .set(headerViewFormer: header)

        former.add(sectionFormers: [section])
    }
}
```

## License
RAReorderableLayout is available under the MIT license. See the LICENSE file for more info.
