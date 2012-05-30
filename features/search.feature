Feature: Searchin
  In order to easily find if my trademark has already been registered
  As a user
  I should be able to search three different databases valid in Slovak Republic from a unified interface

  Scenario: Basic search with a match
    Given I go the search page
    And I submit my query "eset"
    Then I should see a search result "Eset Smart Security"
    And I should see that the mark's number is 218489
    And I should see that the mark's owner is "ESET, spol. s r. o.; Einsteinova 24; 851 01 Bratislava; SK"
