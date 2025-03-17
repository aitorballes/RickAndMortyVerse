import XCTest

class CharactersViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testSearchCharacter() {

        let searchField = app.searchFields["Search characters"]
        searchField.tap()
        searchField.typeText("Rick")

        XCTAssertTrue(
            searchField.waitForExistence(timeout: 5), "Seacher field not found")

        XCTAssertEqual(searchField.value as? String, "Rick")

        let rickText = app.staticTexts["characterName_Rick_Sanchez"]
        XCTAssertTrue(
            rickText.waitForExistence(timeout: 5), "Rick not found in the list")
    }

    func testFilterButtonShowsFilters() throws {
        let genderPicker = app.buttons["genderPicker"]
        let statusPicker = app.buttons["statusPicker"]
        let speciesPicker = app.buttons["speciesPicker"]
        
        XCTAssertFalse(genderPicker.exists)
        XCTAssertFalse(statusPicker.exists)
        XCTAssertFalse(speciesPicker.exists)

        let filterButton = app.buttons["slider.vertical.3"]
        XCTAssertTrue(filterButton.waitForExistence(timeout: 5), "Filters button not found")
        filterButton.tap()

        XCTAssertTrue(genderPicker.waitForExistence(timeout: 5), "Gender picker not found")
        XCTAssertTrue(statusPicker.waitForExistence(timeout: 5), "Status picker not found")
        XCTAssertTrue(speciesPicker.waitForExistence(timeout: 5), "Species picker not found")
    }
}
