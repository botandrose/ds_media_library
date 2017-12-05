Feature: Use media library in forms
  Background:
    Given the following media folders exist:
      | name           | parent_folder  |
      | Example folder |                |
      | Another folder |                |
    Given the following media files exist:
      | file           | parent_folder  |
      | example.jpg    |                |
      | example.mp4    | Example folder |

    Given I am on the homepage

  Scenario: Added media files show in root library
    When I attach the "cat.jpg" file to "Cat picture"
    And I press "Save"
    Then I should see "WIDGET UPDATED"

    When I follow "Manage Media Library"

    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | cat.jpg         |
      | example.jpg     |

  Scenario: Use media library to attach media
    When I open the media library for the "Cat picture"
    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | example.jpg     |

    When I choose "example.jpg"
    Then I should see "example.jpg"

    # state persists when reopening
    When I open the media library for the "Cat picture"
    Then I should see "example.jpg" checked

    # state persists after closing again
    When I close the modal window
    Then I should see "example.jpg"

    # state persists after saving
    When I press "Save"
    Then I should see "WIDGET UPDATED"
    Then I should see "example.jpg"

    # state persists when opening after save
    When I open the media library for the "Cat picture"
    Then I should see "example.jpg" checked

  Scenario: Use media library to select multiple media
    When I open the media library for the "Dog pictures"
    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | example.jpg     |

    When I check "Example folder"
    And I check "example.jpg"
    And I check "example.mp4"
    And I close the modal window
    Then I should see "example.jpg"
    And I should see "example.mp4"

    # state persists when reopening
    When I open the media library for the "Dog pictures"
    And I check "Example folder"
    Then I should see "example.jpg" checked
    And I should see "example.mp4" checked

    # state persists after closing again
    When I close the modal window
    Then I should see "example.jpg"
    And I should see "example.mp4"

    # state persists after saving
    When I press "Save"
    Then I should see "WIDGET UPDATED"
    And I should see "example.jpg"
    And I should see "example.mp4"

    # state persists when opening after save
    When I open the media library for the "Dog pictures"
    And I check "Example folder"
    Then I should see "example.jpg" checked
    And I should see "example.mp4" checked

  Scenario: Removing media doesn't remove it from library
    When I attach the "cat.jpg" file to "Cat picture"
    And I press "Save"
    Then I should see "WIDGET UPDATED"

    When I open the media library for the "Cat picture"
    And I choose "example.jpg"
    And I press "Save"
    Then I should see "WIDGET UPDATED"

    When I follow "Manage Media Library"
    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | cat.jpg         |
      | example.jpg     |

  Scenario: Open all folders
    When I open the media library for the "Cat picture"
    And I follow "Open all folders"
    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | - example.mp4   |
      | example.jpg     |

