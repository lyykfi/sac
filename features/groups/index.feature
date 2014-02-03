Feature: groups index page

  Scenario: Display list of groups
    Given I visits "groups" "index" page
    Then I should see the list of groups

	Scenario: Display CRUD buttons
		Given I visits "groups" "index" page
		Then I should see "delete" button
		And I should see "edit" button
		And I should see "create" button

  Scenario: Display choose checkboxes
		Given I visits "groups" "index" page
		Then I should see choose checkboxes
