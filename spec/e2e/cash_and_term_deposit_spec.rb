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
      pending
      expect(page).to have_content("Some Validation error")
    end
  end
end
