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
Provided by default RowFormer classes and the protocols that corresponding to it are the below.  

##### ○ LabelRowFormer
LabelRowFormer is a class that manages the cell that displays a simple text.  
__Default provided cell:__  
FormLabelCell  
__Protocol:__
```Swift
public protocol LabelFormableRow: FormableRow {    
    func formTextLabel() -> UILabel?
    func formSubTextLabel() -> UILabel?
}
```
__Demo code__  
```Swift
let labelRow = LabelRowFormer<YourLabelCell>()
    .configure {
        $0.text = "main"
        $0.subText = "sub"
    }
```

##### ○ TextFieldRowFormer
TextFieldRowFormer manages the String of the text field on the cell.  
__Default provided cell:__  
FormTextFieldCell
__Protocol:__
```Swift
public protocol TextFieldFormableRow: FormableRow {
    func formTextField() -> UITextField
    func formTitleLabel() -> UILabel?
}
```
__Demo code__  
```Swift
let textFieldRow = TextFieldRowFormer<YourTextFieldCell>() {
    $0.titleLabel.text = "text field"
    }.onTextChanged {
        print($0)
}
```

##### ○ TextViewRowFormer
TextViewRowFormer manages the String of the text view on the cell.  
__Default provided cell:__  
FormTextViewCell  
__Protocol:__
```Swift
public protocol TextViewFormableRow: FormableRow {
    func formTitleLabel() -> UILabel?
    func formTextView() -> UITextView
}
```
__Demo code__  
```Swift
let textViewRow = TextViewRowFormer<FormTextViewCell>() {
    $0.titleLabel.text = "text view"
    }.onTextChanged {
        print($0)
}
```

##### ○ CheckRowFormer
CheckRowFormer is manage a Bool value with check mark display on the cell.  
It's also possible to use the custom view instead of check mark.  
__Default provided cell:__  
FormCheckCell  
__Protocol:__
```Swift
public protocol CheckFormableRow: FormableRow {    
    func formTitleLabel() -> UILabel?
}
```
__Demo code__  
```Swift
let checkRow = CheckRowFormer<YourCheckCell>() {
    $0.titleLabel.text = "check"
    }.onCheckChanged {
        if $0 { print("Check!") }
}
```

##### ○ SwitchRowFormer
SwitchRowFormer is manage the switch change events on the cell.  
__Default provided cell:__  
FormCheckCell  
__Protocol:__
```Swift
public protocol SwitchFormableRow: FormableRow {
    func formSwitch() -> UISwitch
    func formTitleLabel() -> UILabel?
}
```
__Demo code__  
```Swift
let switchRow = SwitchRowFormer<YourSwitchCell>() {
    $0.titleLabel.text = "switch"
    }.onSwitchChanged {
        if $0 { print("Switch On!") }
}
```


## License
Former is available under the MIT license. See the LICENSE file for more info.
