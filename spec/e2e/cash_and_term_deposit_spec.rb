# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Cash and Term DepositCalculator", :js, type: :feature do
  scenario "calculates cash deposit with top ups and term deposit" do
    Given "I visit the home page" do
      visit "/"
    end

    Then "I should see errors prompting to fill the form" do
      pending
      expect(page).to have_content("Please select Cash or TermDeposit")
      expect(page).to have_content("Please fill the form")
    end
  end
end
