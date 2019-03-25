require 'application_system_test_case'

class VisitsTest < ApplicationSystemTestCase
  test 'visiting the index' do
    visit root_path

    # debugger

    assert_selector 'h1', text: 'Listing visits'
  end
end
