![Former](https://raw.githubusercontent.com/ra1028/Former/master/Logo.png)
#### Former is a fully customizable Swift2 library for easy creating UITableView based form.
![iOS 7.0+](https://img.shields.io/badge/iOS-7.0%2B-blue.svg) [![Swift2](https://img.shields.io/badge/swift2-compatible-4BC51D.svg?style=flat)](https://developer.apple.com/swift)
[![CocoaPods Shield](https://img.shields.io/cocoapods/v/Former.svg)](https://cocoapods.org/pods/Former)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![MIT License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/ra1028/Former/master/LICENSE)

## Overview
<img src="http://i.imgur.com/1gOwZZN.gif" width="220">
<img src="http://i.imgur.com/g9yeTtV.gif" width="220">
<img src="http://i.imgur.com/ouM1SsG.gif" width="220">

## Contents
* [Requirements](#Requirements)
* [Installation](#installation)
* [Usage](#usage)
  + [Simple Example](#simple-example)
  + [RowFormer](#rowformer)
  + [ViewFormer](#viewformer)
  + [SectionFormer](#sectionformer)
  + [Former](#former)
  + [Customizability](#customizability)
* [License](#license)

## Requirements  
- Xcode 7+
- iOS 7.0+
- Swift 2.0+

## Installation
### iOS 8.0+
#### [CocoaPods](https://cocoapods.org/)
Add the following line to your Podfile:
```ruby
use_frameworks!
pod "Former"
```
#### [Carthage](https://github.com/Carthage/Carthage)
Add the following line to your Cartfile:
```ruby
github "ra1028/Former"
```

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

## Usage
You can setting the cell appearance and events callback at the same time.  
ViewController and Cell does not need to override the ones that are provided by default.  
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
RowFormer is base of the class that manages the cell.  
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
<td>Free</td>
<td>CustomRowFormer</td>
<td>None</td>
<td>None</td>
</tr>
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
<td><img src="http://i.imgur.com/jUn8Get.gif" width="200"></td>
<td>SelecterPickerRowFormer</td>
<td>SelecterPickerFormableRow</td>
<td>FormSelecterPickerCell</td>
</tr>
<tr>
<td><img src="http://i.imgur.com/VfxaKoL.gif" width="200"></td>
<td>SelecterDatePickerRowFormer</td>
<td>SelecterDatePickerFormableRow</td>
<td>FormSelecterDatePickerCell</td>
</tr>
<tr>
<td><img src="http://i.imgur.com/NHb6SXy.gif" width="200"></td>
<td>InlinePickerRowFormer</td>
<td>InlinePickerFormableRow</td>
<td>FormInlinePickerCell</td>
</tr>
<tr>
<td><img src="http://i.imgur.com/g0M2U4T.gif" width="200"></td>
<td>InlineDatePickerRowFormer</td>
<td>InlineDatePickerFormableRow</td>
<td>FormInlineDatePickerCell</td>
</tr>
</tbody>
</table>

__example with LabelRowFormer__  
```Swift
let labelRow = LabelRowFormer<YourLabelCell>(instantiateType: .Nib(nibName: "YourLabelCell")) {
    $0.titleLabel.textColor = .blackColor()
    }.configure { row in
        row.rowHeight = 44
        row.text = "Label Cell"
    }.onSelected { row in
        print("\(row.text) Selected !!")
}
```
__update the cell__
```Swift
row.update()
row.update { row in
    row.text = "Updated title"
}
row.cellUpdate { cell in
    cell.titleLabel.textColor = .redColor()
}
```
__get cell instance__
```Swift
let cell = row.cell
print(cell.titleLabel.text)
```
__set dynamic row height__
```Swift
row.dynamicRowHeight { tableView, indexPath -> CGFloat in
    return 100
}
```


### ViewFormer
ViewFormer is base of the class that manages the HeaderFooterView.  
HeaderFooterView that managed by the ViewFormer class should conform to the corresponding protocol.  
Default provided ViewFormer classes and the protocols that corresponding to it are the below.  

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
<td>Free</td>
<td>CustomViewFormer</td>
<td>None</td>
<td>None</td>
</tr>
<tr>
<td><img src="http://i.imgur.com/Vmmk0dc.png" width="200"></td>
<td>LabelViewFormer</td>
<td>LabelFormableView</td>
<td>
FormLabelHeaderView  
FormLabelFooterView
</td>
</tr>
</tbody>
</table>

__example with LabelViewFormer__
```Swift
let headerView = LabelViewFormer<YourLabelView>(instantiateType: .Nib(nibName: "YourLabelView")) {
    $0.titleLabel.textColor = .blackColor()
    }.configure { view in
        view.viewHeight = 30
        view.text = "Label HeaderFooter View"
}
```


### SectionFormer
SectionFormer is a class that represents the Section of TableView.  
SectionFormer can append, add, insert, remove the RowFormer and set the ViewFormer.  
__example__  
```Swift
let section = SectionFormer(rowFormer: row1, row2, row3)
    .set(headerViewFormer: headerView)
    .set(footerViewFormer: footerView)
```
__add the cell__
```
section.append(rowFormer: row1, row2, row3)
section.add(rowFormers: rows)
section.insert(rowFormer: row, toIndex: 3)
section.insert(rowFormer: row, below: otherRow)
// etc...
```
__remove the cell__
```Swift
section.remove(0)
section.remove(0...5)
section.remove(rowFormer: row)
// etc...
```
__set the HeaderFooterViewe__
```Swift
section.set(headerViewFormer: headerView)
section.set(footerViewFormer: footerView)
```


### Former
Former is a class that manages the entire form.  
Examples is below.  
__add the section or cell__
```Swift
former.append(sectionFormer: row)
former.add(sectionFormers: rows)
former.insert(sectionFormer: section, toSection: 0)
former.insert(rowFormer: row, toIndexPath: indexPath)
former.insert(sectionFormer: section, above: otherSection)
former.insert(rowFormers: row, below: otherRow)
// etc...

// with animation
former.insertUpdate(sectionFormer: section, toSection: 0, rowAnimation: .Automatic)
former.insertUpdate(rowFormer: row, toIndexPath: indexPath, rowAnimation: .Left)
former.insertUpdate(sectionFormer: section, below: otherSection, rowAnimation: .Fade)
former.insertUpdate(rowFormers: rows, above: otherRow, rowAnimation: .Bottom)
// etc...
```
__remove the section or cell__
```Swift
former.removeAll()
former.remove(rowFormer: row1, row2)
former.remove(sectionFormer: section1, section2)
// etc...

// with animation
former.removeAllUpdate(.Fade)
former.removeUpdate(sectionFormers: sections, rowAnimation: .Middle)
// etc...
```
__Select and deselect the cell__
```Swift
former.select(indexPath: indexPath, animated: true, scrollPosition: .Middle)
former.select(rowFormer: row, animated: true)
former.deselect(true)
// etc...
```
__end editing__
```Swift
former.endEditing()
```
__become editing next/previous cell__
```Swift
if former.canBecomeEditingNext() {
    former.becomeEditingNext()
}
if former.canBecomeEditingPrevious() {
    former.becomeEditingPrevious()
}
```
__functions to setting event handling__
```Swift
public func onCellSelected(handler: (NSIndexPath -> Void)) -> Self
public func onScroll(handler: ((scrollView: UIScrollView) -> Void)) -> Self    
public func onBeginDragging(handler: (UIScrollView -> Void)) -> Self
public func willDeselectCell(handler: (NSIndexPath -> NSIndexPath?)) -> Self
public func willDisplayCell(handler: (NSIndexPath -> Void)) -> Self
public func willDisplayHeader(handler: (/*section:*/Int -> Void)) -> Self
public func willDisplayFooter(handler: (/*section:*/Int -> Void)) -> Self        
public func didDeselectCell(handler: (NSIndexPath -> Void)) -> Self
public func didEndDisplayingCell(handler: (NSIndexPath -> Void)) -> Self
public func didEndDisplayingHeader(handler: (/*section:*/Int -> Void)) -> Self
public func didEndDisplayingFooter(handler: (/*section:*/Int -> Void)) -> Self
public func didHighlightCell(handler: (NSIndexPath -> Void)) -> Self
public func didUnHighlightCell(handler: (NSIndexPath -> Void)) -> Self
```


### Customizability
__ViewController__  
There is no need to inherit the FormViewController.  
Create an instance of UITableView and Former, as in the following example.
```Swift
final class YourViewController: UIViewController {    

    private let tableView: UITableView = UITableView(frame: CGRect.zero, style: .Grouped) // It may be IBOutlet. Not forget to addSubview.
    private lazy var former: Former = Former(tableView: self.tableView)

    ...
```
__Cell__
Need not to inherit the default provided cell (FormLabelCell etc ...), but need conform to the corresponding protocol.
You can use course Nib.
Example with LabelRowFormer:
```Swift
final class YourCell: UITableViewCell, LabelFormableRow {

    // MARK: LabelFormableRow

    func formTextLabel() -> UILabel? {
        return titleLabel
    }

    func formSubTextLabel() -> UILabel? {
        return subTitleLabel
    }

    func updateWithRowFormer(rowFormer: RowFormer) {
        // Do something
    }

    // MARK: UITableViewCell

    var titleLabel: UILabel?
    var subTitleLabel: UILabel?

    ...
```
__RowFormer__
If you want to create a custom RowFormer, inherits the BaseRowFormer and comply with the Formable protocol.  
It must conform to In ConfigurableInlineForm in case of InlineRowFomer, conform to UpdatableSelectorForm case of SelectorRowFormer.
Please look at the source code for details.  
Examples of RowFormer of cells with two a UITextField:  
```Swift
public protocol DoubleTextFieldFormableRow: FormableRow {

    func formTextField1() -> UITextField
    func formTextField2() -> UITextField
}

public final class DoubleTextFieldRowFormer<T: UITableViewCell where T: DoubleTextFieldFormableRow>
: BaseRowFormer<T>, Formable {

    // MARK: Public

    override public var canBecomeEditing: Bool {
        return enabled
    }

    public var text1: String?
    public var text2: String?

    public required init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }

    public final func onText1Changed(handler: (String -> Void)) -> Self {
        onText1Changed = handler
        return self
    }

    public final func onText2Changed(handler: (String -> Void)) -> Self {
        onText2Changed = handler
        return self
    }

    public override func cellInitialized(cell: T) {
        super.cellInitialized(cell)
        cell.formTextField1().addTarget(self, action: "text1Changed:", forControlEvents: .EditingChanged)
        cell.formTextField2().addTarget(self, action: "text2Changed:", forControlEvents: .EditingChanged)
    }

    public override func update() {
        super.update()

        cell.selectionStyle = .None
        let textField1 = cell.formTextField1()
        let textField2 = cell.formTextField2()
        textField1.text = text1
        textField2.text = text2        
    }

    // MARK: Private

    private final var onText1Changed: (String -> Void)?
    private final var onText2Changed: (String -> Void)?    

    private dynamic func text1Changed(textField: UITextField) {
        if enabled {
            let text = textField.text ?? ""
            self.text1 = text
            onText1Changed?(text)
        }
    }

    private dynamic func text2Changed(textField: UITextField) {
        if enabled {
            let text = textField.text ?? ""
            self.text2 = text
            onText2Changed?(text)
        }
    }
}
```

## License
Former is available under the MIT license. See the LICENSE file for more info.
