require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    url = Nokogiri::HTML(open(index_url))
    url.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        profile_link = student.attr("href")
        student_name = student.css(".student-name").text
        student_location = student.css(".student-location").text
        students << {name: student_name, location: student_location, profile_url: profile_link}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    students = {}
    url = Nokogiri::HTML(open(profile_url))
    social_links = url.css("div.social-icon-container").children.css("a").collect do |social|
      social.attribute("href").value
    end
      social_links.each do |link|
        # binding.pry
        if link.include?("twitter")
          students[:twitter] = link
        elsif link.include?("linkedin")
          students[:linkedin] = link
        elsif link.include?("github")
          students[:github] = link
        else
          students[:blog] = link
        end
      end
    students[:profile_quote] = url.css(".profile-quote").text if url.css(".profile-quote")
    students[:bio] = url.css(".description-holder p").text if url.css(".description-holder p")

    students
  end

end

