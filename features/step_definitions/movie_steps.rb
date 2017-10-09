# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)

  page.uncheck("ratings_G")
  page.uncheck("ratings_PG-13")
  page.uncheck("ratings_PG")
  page.uncheck("ratings_R")

  ratings = arg1.split(",").map(&:strip)
  ratings.each do |rating|
	  page.check("ratings_#{rating}") 
  end
  find_button('ratings_submit').click
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
  ratings = arg1.split(",").map(&:strip)
  ratings.each do |rating|
	# movies = Movie.find_all_by_rating(rating)
	movies = Movie.where(rating:ratings).all
	  movies.each do |movie|
	    expect(page).to have_content(movie.title)
	  end
  end
end

Then /^I should see all of the movies$/ do
  (Movie.count).should == all("table#movies tbody tr").count
end

When(/^I click Movie Title$/) do
  click_link "title_header"
end

Then(/^I should see "(.*?)" before "(.*?)"$/) do |arg1, arg2|
  regexpr = /#{arg1}.*#{arg2}.*/m
  a=false
  if (page.source =~ regexpr)
    a=true
  end
  expect(a).to be_truthy
 end    
 
When(/^I click Release Date$/) do
  click_link "release_date_header"
end
 
Then(/^I should see "(.*?)" before I see "(.*?)"$/) do |arg1, arg2|
  regexpr = /#{arg1}.*#{arg2}.*/m
  a=false
  if (page.source =~ regexpr)
    a=true
  end
  expect(a).to be_truthy
 end   



