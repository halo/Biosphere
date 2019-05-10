import XCTest
@testable import Biosphere

class PathTests: XCTestCase {
  
  func testHelperDirectory() {
    let path = Paths.helperDirectory
    XCTAssertEqual("/Library/PrivilegedHelperTools", path)
  }
  
  func testHelperDirectoryURL() {
    let url = Paths.helperDirectoryURL
    XCTAssertEqual("/Library/PrivilegedHelperTools", url.path)
  }
  
  func testHelperExecutable() {
    let path = Paths.helperExecutable
    XCTAssertEqual("/Library/PrivilegedHelperTools/io.github.halo.biohelper", path)
  }
  
  func testHelperExecutableURL() {
    let url = Paths.helperExecutableURL
    XCTAssertEqual("/Library/PrivilegedHelperTools/io.github.halo.biohelper", url.path)
  }

  func testDaemonsPlistDirectory() {
    let path = Paths.daemonsPlistDirectory
    XCTAssertEqual("/Library/LaunchDaemons", path)
  }
  
  func testDaemonsPlistDirectoryURL() {
    let url = Paths.daemonsPlistDirectoryURL
    XCTAssertEqual("/Library/LaunchDaemons", url.path)
  }
  
  func testHelperPlistFile() {
    let path = Paths.helperPlistFile
    XCTAssertEqual("/Library/LaunchDaemons/io.github.halo.biohelper.plist", path)
  }
  
  func testHelperPlistFileURL() {
    let url = Paths.helperPlistFileURL
    XCTAssertEqual("/Library/LaunchDaemons/io.github.halo.biohelper.plist", url.path)
  }
}
