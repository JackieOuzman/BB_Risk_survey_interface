### download Kobotoolbox data in R https://www.r-bloggers.com/2022/03/how-to-download-kobotoolbox-data-in-r/

#install.packages("KoboconnectR")
#install.packages("devtools")  # Install devtools first, if not already installed


#devtools::install_github("asitav-sen/KoboconnectR")


library(KoboconnectR)



get_kobo_token(url="kobo.humanitarianresponse.info", 
               uname="userid", 
               pwd="password")


KoboconnectR::kobotools_api(url="https://kf.kobotoolbox.org/api/v2/assets/aBuC7N2fuqWo7BkJfgHYcX/export-settings/esRMkzGooa8ZgP76sAk677o/data.csv", 
                            simplified=T#, 
                            #uname="userid", 
                            #pwd="password"
                            )


##################################################################################

### maybe we are over thinking it:)

raw_data <- read.csv("https://kf.kobotoolbox.org/api/v2/assets/aBuC7N2fuqWo7BkJfgHYcX/export-settings/esRMkzGooa8ZgP76sAk677o/data.csv", sep=';')

names(raw_data)
