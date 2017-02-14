# HKSplitMenu

HKSplitMenu 是一个类似于 UISplitViewController 的分割视图控制器，它支持 iPhone 和 iPad，并且针对不同的 SizeClass 进行了适配。
</br>
HKSplitMenu 可以自定义菜单栏的宽度，并且在窄屏幕的设备上可以自动切换为侧滑菜单模式，支持iPad分屏模式。
</br>
HKSplitMenu 在侧滑模式下支持从屏幕边缘滑动显示菜单栏。

显示效果如图：

![image](../Image.png)


## 安装

#### 通过 CocoaPods 安装

```
pod 'HKSplitMenu', :git => 'https://github.com/Harley-xk/HKSplitMenu.git'
```

#### 手动安装
直接将 HKSplitMenu 及其中的文件拖到工程中即可。

## 使用
HKSplitMenu 使用非常简单，只需要继承 HKSplitMenu，并且设置 Menu 属性为自定义的视图控制器即可，详细使用可以参考示例程序

## API 说明

```swift
extension UIViewController {
    /// 获取当前视图的分栏菜单，不存在则返回 nil
    public var splitMenu: HKSplitMenu.HKSplitMenu? { get }
}
```
通过该扩展可以获取当前视图控制器所在的分割视图控制器（如果有的话），该方法会遍历当前视图控制器的所有父视图控制器，直到找到 HKSplitMenu 为止，否则返回空

```swift
open class HKSplitMenu : UIViewController
```
HKSplitMenu 是一个视图控制器，负责管理菜单视图控制器和内容视图控制器。

```swift
open var menuWidth: CGFloat
```
左侧菜单栏的宽度，支持自定义，默认为64，修改该属性后会立即生效。


```swift
open var menu: UIViewController?
```
菜单视图控制器，固定显示在左侧

```swift
open var content: UIViewController? { get }
```
当前显示的内容视图控制器，只读属性，需要通过下面两个方法来设置

```swift
open func setContent(for identifier: String, forceUpdate: Bool = default, provider: () -> (UIViewController))
```
内容视图通过 identifier 进行缓存，以保证重新打开该视图时能保持原先的状态。</br>
调用该方法时，首先会查找与 identifier 匹配的缓存，如果对应的缓存不存在，那么 provider 闭包将会被调用，provider 闭包要求返回一个新的视图控制器，这个视图控制器会对应 identifier 进行缓存。</br>
如果缓存存在，则根据 forceUpdate 判断是否需要强制更新，不需要强制更新则使用缓存中的值，更新当前显示的内容视图。否则调用 provider 获取新的内容视图并缓存。

```swift
open func setContent(_ content: UIViewController)
```
更新当前显示的内容视图，调用该方法时，将显示提供的新的内容视图，该视图不会被缓存

```swift
open func toggleMenu()
```
切换菜单的状态（显示或隐藏），如果菜单被锁定，则调用该方法不会有任何效果

```swift
open var isMenuFixed: Bool { get }
```
获取当前菜单是否被锁定的状态，HKSplitMenu 会自动根据当前的 SizeClass 属性调整锁定状态

```swift
open var isMenuShown: Bool { get }
```
获取菜单的当前显示状态

```swift
open func cacheContent(_ content: UIViewController, for identifier: String)
```
缓存一个内容视图控制器到指定的 identifier，已经存在的缓存会被更新

```swift
open func showMenu()
```
显示菜单，如果菜单已经显示，或者菜单被锁定，则不会有任何效果

```swift
 open func hideMenu()
```
隐藏菜单，如果菜单已经隐藏，或者菜单被锁定，则不会有任何效果

```swift
open var panGestureEdge: CGFloat
```
当菜单处于侧滑模式时，从屏幕边缘侧滑可以开启菜单，这个参数设置响应侧滑手势的宽度范围，默认为 30 </br>
只有当手势起点到屏幕左边的距离小于等于该值时，才会执行显示菜单的逻辑

```swift
open var panGestureMaxOffset: CGFloat
```
当菜单处于侧滑模式，并且通过手势向右滑动内容视图时，该值影响内容视图向右滑动的最大距离，默认为 200


## License

HKSplitMenu is available under the MIT license. See the LICENSE file for more info.
