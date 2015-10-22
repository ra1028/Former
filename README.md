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

To be supported: iOS7.0+

## Usage (example)
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
                // Datepicker cell setup
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
        }
    }
}
```
__OR__
```swift
final class YourViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        former.append(sectionFormer:

            SectionFormer().append(rowFormer:

                LabelRowFormer<FormLabelCell>() {                    
                    // Cell setup
                    }.configure {                        
                        // RowFormer setup
                    }.onSelected {                        
                        // Selection handler
                }
                ).append(rowFormer:

                    InlineDatePickerRowFormer<FormInlineDatePickerCell>() {                        
                        // Cell setup
                        }.configure {                    
                            // Row Former setup
                        }.onDateChanged {                            
                            // Value change handler
                        }.inlineCellSetup {                            
                            // Datepicker cell setup
                    }
                )
                .set(headerViewFormer:

                    LabelViewFormer<FormLabelHeaderView>() {                        
                        // Header view setup
                        }.configure {                    
                            // ViewFormer setup
                    }
            )
        )
    }
}
```

## License
Former is available under the MIT license. See the LICENSE file for more info.
