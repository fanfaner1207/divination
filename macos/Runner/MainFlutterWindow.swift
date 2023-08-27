import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
<<<<<<< HEAD
    let flutterViewController = FlutterViewController.init()
=======
    let flutterViewController = FlutterViewController()
>>>>>>> flutter_3.13.0
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
