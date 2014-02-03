Given /^I visits "([^"]*)" "([^"]*)" page$/ do |controller, method|
	method = "" if method == "index"
	visit "/#{controller}/#{method}"
end

Then /^I should see the list of groups$/ do
	page.should have_content(Group.first.name)
	page.should have_content(Group.last.name)
end

Then /^I should see "([^"]*)" button$/ do |button|
	case button
		when "create" then page.should have_selector('.btn.btn-primary')
		when "edit" then page.should have_selector('.btn.btn-success')
		when "delete" then page.should have_selector('.btn.btn-danger')
		else
			pending
	end
end

Then /^I should see choose checkboxes$/ do
	page.should have_selector('.check-row')
end

When /^checkbox "([^"]*)" is unchecked$/ do |arg|
	page.should have_selector(arg)
	find(arg).should_not be_checked
end

When /^I check checkbox "([^"]*)"$/ do |arg|
	page.should have_selector(arg)
	find(arg).set(true)
end

Then /^all checkboxes "([^"]*)" are checked$/ do |arg|
	find(arg).each { |chb| chb.should be_checked }
end

When /^checkbox "([^"]*)" is checked$/ do |arg|
	page.should have_selector(arg)
	find(arg).should be_checked
end

When /^I uncheck checkbox "([^"]*)"$/ do |arg|
	page.should have_selector(arg)
	find(arg).set(false)
end

Then /^all checkboxes "([^"]*)" are unchecked$/ do |arg|
	find(arg).each { |chb| chb.should_not be_checked }
end