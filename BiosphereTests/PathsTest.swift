import XCTest
@testable import Biosphere

class PathTests: XCTestCase {
  
  func testCacheDirectory() {
    let path = Paths.cacheDirectory
    XCTAssertEqual("/Users/\(NSUserName())/Library/Caches/io.github.halo.Biosphere", path)
  }

  func testConfigDirectory() {
    let path = Paths.configDirectory
    XCTAssertEqual("/Users/\(NSUserName())/Library/Application Support/io.github.halo.Biosphere", path)
  }

}
