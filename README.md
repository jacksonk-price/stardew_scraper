# stardew_scraper
Ruby scripts that use Selenium to collect information on the video game Stardew Valley from the Stardew Valley Wiki. https://stardewvalleywiki.com/Stardew_Valley_Wiki

## What does each script do?

### item_scraper.rb
This script collects the each available item in the game and stores them into a database using ActiveRecord.

### villager_name_scraper.rb
This script collects and outputs an array of each villager's name within the game. These names are then utilized in the following script to collect more information on each villager.


### main_scraper.rb
This script uses the names collected in the script above to retrieve and store information for each individual villager into a database.
