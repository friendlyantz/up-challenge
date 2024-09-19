# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Cash and Term DepositCalculator", :js, type: :feature do
  scenario "calculates cash deposit with top ups and term deposit" do
    Given "I visit the home page" do
      visit "/"
    end

    Then "I should see errors prompting to fill the form" do
      expect(page).to have_content("Please select Cash or TermDeposit")
      expect(page).to have_content("Please fill the form")
    end

    When "I select Term Deposit" do
      click_button "TermDeposit"
    end

    Then "relevant errors should dissapear" do
      expect(page).to have_content("Please fill the form")
      expect(page).not_to have_content("Please select Cash or TermDeposit")
    end

    When "I fill the form with INVALID params" do
      fill_in "principal", with: "invalid input"
      fill_in "interest_rate", with: 99_999_999_999
      fill_in "term", with: -1
      choose "Monthly"
    end

    Then "I should see errors prompting to fill the form" do
      expect(page).to have_content("Principal is not a number")
      expect(page).to have_content("Term must be greater than 0")
      expect(page).to have_content("Interest rate must be less than 1")
    end

    When "I fill the form with valid params" do
      fill_in "principal", with: 10_000.00
      fill_in "interest_rate", with: 0.12
      fill_in "term", with: 1.0
      choose "Monthly"
    end

    Then "I should see the final balance and total interest earned" do
      expect(page.find("#final-balance")).to have_content("$11,268.25")
      expect(page.find("#total-interest")).to have_content("$1,268.25")
    end

    When "I select Cash" do
      click_button "Cash"
    end

    And "I fill the form with WEEKLY compounding AND top ups" do
      fill_in "principal", with: 10_000.00
      fill_in "interest_rate", with: 0.12
      fill_in "term", with: 1.0
      fill_in "top_up", with: 100.00
      choose "Weekly"
    end

    Then "I should see the final balance and total interest earned" do
      pending

      expect(page.find("#final-balance")).to have_content("$16,791.52")
      expect(page.find("#total-interest")).to have_content("$1,591.52")
    end
  end
end
