import XCTest
@testable import Biosphere

class PathTests: XCTestCase {

  func testCacheDirectory() {
    let path = Paths.cacheDirectory
    XCTAssertEqual("/Users/\(NSUserName())/Library/Caches/io.github.halo.Biosphere", path)
  }

  func testChefKnifeConfig() {
    let path = Paths.chefKnifeConfig
    XCTAssertEqual("/Users/\(NSUserName())/Library/Caches/io.github.halo.Biosphere/knife.rb", path)
  }

  func testChefSoloConfig() {
    let path = Paths.chefSoloConfig
    XCTAssertEqual("/Users/\(NSUserName())/Library/Caches/io.github.halo.Biosphere/solo.json", path)
  }

  func testChefCacheDirectory() {
    let path = Paths.chefCacheDirectory
    XCTAssertEqual("/Users/\(NSUserName())/Library/Caches/io.github.halo.Biosphere/cache", path)
  }

  func testChefChecksumsDirectory() {
    let path = Paths.chefChecksumsDirectory
    XCTAssertEqual("/Users/\(NSUserName())/Library/Caches/io.github.halo.Biosphere/checksums", path)
  }

  func testChefBackupsDirectory() {
    let path = Paths.chefBackupsDirectory
    XCTAssertEqual("/Users/\(NSUserName())/Library/Caches/io.github.halo.Biosphere/backups", path)
  }

  func testConfigDirectory() {
    let path = Paths.configDirectory
    XCTAssertEqual("/Users/\(NSUserName())/Library/Application Support/io.github.halo.Biosphere", path)
  }

}

