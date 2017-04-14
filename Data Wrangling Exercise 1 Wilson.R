raw_data <- read.csv("refine_original.csv")
install.packages("tidyverse")
library(tidyverse)
library(stringr)

# clean up brand names

clean_col <- raw_data %>% 
  mutate(lower_company = tolower(company),
         first_letter = substr(lower_company, 0, 1), 
         clean_company = ifelse(first_letter == "p", "phillips", 
                                ifelse(first_letter == "a", "akzo",
                                       ifelse(first_letter == "v", "van Houten",
                                              ifelse(first_letter == "u", "unliever", first_letter))))) 
# Add product categories

product_code_map <- data.frame(
  product_code = c("p", "v", "x", "q"),
  product_name = c("Smartphone", "TV", "Laptop", "Tablet")
)  


# Separate product code and number / Add full address for geocoding

sep_clean_data <- clean_col %>% 
  rename(product_code_number = `Product.code...number`) %>% 
  separate(col = product_code_number, 
           into = c("code", "product_number"),
           sep = "-") %>% 
  left_join(y = product_code_map, 
            by = c("code" = "product_code")) %>% 
  mutate(full_address = paste(address, city, country, sep = ", ")) 


#Create dummy variables for company and product category

sep_clean_data$company_philips <- as.numeric(sep_clean_data$company == "philips")
sep_clean_data$company_azko <- as.numeric(sep_clean_data$company == "akzo")  
sep_clean_data$company_van_houten <- as.numeric(sep_clean_data$company == "van Houten")
sep_clean_data$company_unilever <- as.numeric(sep_clean_data$company == "unilever")

sep_clean_data$product_smartphone <- as.numeric(sep_clean_data$product_name == "Smartphone")
sep_clean_data$product_tv <- as.numeric(sep_clean_data$product_name == "TV")
sep_clean_data$product_laptop <- as.numeric(sep_clean_data$product_name == "Laptop")
sep_clean_data$product_tablet <- as.numeric(sep_clean_data$product_name == "Tablet")

write.csv(sep_clean_data, "data_wrangling_1_wilson.csv")
