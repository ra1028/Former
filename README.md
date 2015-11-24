![Former](https://raw.githubusercontent.com/ra1028/Former/master/Logo.png)
#### Former is a fully customizable Swift2 library for easy creating UITableView based form.
![iOS 7.0+](https://img.shields.io/badge/iOS-7.0%2B-blue.svg) [![Swift2](https://img.shields.io/badge/swift2-compatible-4BC51D.svg?style=flat)](https://developer.apple.com/swift)
<!-- [![CocoaPods Shield](https://img.shields.io/cocoapods/v/Former.svg)](https://cocoapods.org/pods/Former) -->
<!-- [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) -->
[![MIT License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/ra1028/Former/master/LICENSE)

## Requirements  
- Xcode 7+
- iOS 7.0+
- Swift 2.0+

## Overview
<img src="http://i.imgur.com/1gOwZZN.gif" width="220">
<img src="http://i.imgur.com/g9yeTtV.gif" width="220">
<img src="http://i.imgur.com/ouM1SsG.gif" width="220">

## Installation
### iOS 8.0+
Coming soon...
<!-- #### [CocoaPods](https://cocoapods.org/)
Add the following line to your Podfile:
```ruby
use_frameworks!
pod "Former"
```
#### [Carthage](https://github.com/Carthage/Carthage)
Add the following line to your Cartfile:
```ruby
github "ra1028/Former"
``` -->

### iOS 7.0+
#### [git submodule](http://git-scm.com/docs/git-submodule)
Run the following command:
```shell
git submodule add https://github.com/ra1028/Former.git
```
#### [CocoaSeeds](https://github.com/devxoul/CocoaSeeds)
Add the following line to your Seedfile:
```ruby
github "ra1028/Former", :files => "Former/**/*.{swift,h}"
```

## Usage(WIP)
You can setting the cell appearance and events callback at the same time.  
ViewController and Cell does not need to override.  
### Simple Example
```Swift
import Former

final class ViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let labelRow = LabelRowFormer<FormLabelCell>()
            .configure { row in
                row.text = "Label Cell"
            }.onSelected { row in
                // Do Something
        }
        let inlinePickerRow = InlinePickerRowFormer<FormInlinePickerCell, Int>() {
            $0.titleLabel.text = "Inline Picker Cell"
            }.configure { row in
                row.pickerItems = (1...5).map {
                    InlinePickerItem(title: "Option\($0)", value: Int($0))
                }
            }.onValueChanged { item in
                // Do Something
        }
        let header = LabelViewFormer<FormLabelHeaderView>() { view in
            view.titleLabel.text = "Label Header"
        }
        let section = SectionFormer(rowFormer: labelRow, inlinePickerRow)
            .set(headerViewFormer: header)
        former.append(sectionFormer: section)
    }
}
```


### RowFormer
RowFormer is the base of the class that manages the cell.  
Cell that managed by the RowFormer class should conform to the corresponding protocol.  
Each of RowFormer classes You can set the event handling in function named like on~ (onSelected, onValueChanged, etc...)  
Default provided RowFormer classes and the protocols that corresponding to it are the below.  

<table>
<thead>
<tr>
<th>Demo</th>
<th>Class</th>
<th>Protocol</th>
<th>Default provided cell</th>
</tr>
</thead>

<tbody>
<tr>
<td><img src="http://i.imgur.com/ZTzZAG3.gif" width="200"></td>
<td>LabelRowFormer</td>
<td>LabelFormableRow</td>
<td>FormLabelCell</td>
</tr>
<tr>
<td><img src="http://i.imgur.com/sLfvbRz.gif" width="200"></td>
<td>TextFieldRowFormer</td>
<td>TextFieldFormableRow</td>
<td>FormTextFieldCell</td>
</tr>
<tr>
<td><img src="http://i.imgur.com/Es7JOYk.gif" width="200"></td>
<td>TextViewRowFormer</td>
<td>TextViewFormableRow</td>
<td>FormTextViewCell</td>
</tr>
<tr>
<td><img src="http://i.imgur.com/FjrTL51.gif" width="200"></td>
<td>CheckRowFormer</td>
<td>CheckFormableRow</td>
<td>FormCheckCell</td>
</tr>
<tr>
<td><img src="http://i.imgur.com/AfidFhs.gif" width="200"></td>
<td>SwitchRowFormer</td>
<td>SwitchFormableRow</td>
<td>FormSwitchCell</td>
</tr>
<tr>
<td><img src="http://i.imgur.com/ACeA4uq.gif" width="200"></td>
<td>StepperRowFormer</td>
<td>StepperFormableRow</td>
<td>FormStepperCell</td>
</tr>
<tr>
<td><img src="http://i.imgur.com/0KAJK6v.gif" width="200"></td>
<td>SegmentedRowFormer</td>
<td>SegmentedFormableRow</td>
<td>FormSegmentedCell</td>
</tr>
<tr>
<td><img src="http://i.imgur.com/i2ibb0P.gif" width="200"></td>
<td>SliderRowFormer</td>
<td>SliderFormableRow</td>
<td>FormSliderCell</td>
</tr>
<tr>
<td><img src="http://i.imgur.com/Vkfxf2P.gif" width="200"></td>
<td>PickerRowFormer</td>
<td>PickerFormableRow</td>
<td>FormPickerCell</td>
</tr>
<tr>
<td><img src="http://i.imgur.com/MLHG4oP.gif" width="200"></td>
<td>DatePickerRowFormer</td>
<td>DatePickerFormableRow</td>
<td>FormDatePickerCell</td>
</tr>
<tr>
<td></td>
<td>SelecterPickerRowFormer</td>
<td>SelecterPickerFormableRow</td>
<td>FormSelecterPickerCell</td>
</tr>
<tr>
<td></td>
<td>SelecterDatePickerRowFormer</td>
<td>SelecterDatePickerFormableRow</td>
<td>FormSelecterDatePickerCell</td>
</tr>
<tr>
<td></td>
<td>InlinePickerRowFormer</td>
<td>InlinePickerFormableRow</td>
<td>FormInlinePickerCell</td>
</tr>
<tr>
<td></td>
<td>InlineDatePickerRowFormer</td>
<td>InlineDatePickerFormableRow</td>
<td>FormInlineDatePickerCell</td>
</tr>

</tbody>
</table>


## License
Former is available under the MIT license. See the LICENSE file for more info.
