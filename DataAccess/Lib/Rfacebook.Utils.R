library(Rfacebook);

fb_oauth <-
  fbOAuth(app_id="123456789", app_secret="1A2B3C4D",extended_permissions = TRUE);

save(fb_oauth, file="fb_oauth");
load("fb_oauth");
me <- getUsers("me",token=fb_oauth);
my_likes <- getLikes(user="me", token=fb_oauth);

###

token <- 'YOUR AUTHENTICATION TOKEN';
me <- getUsers("me", token, private_info=TRUE);
getUsers(c("barackobama", "donaldtrump"), token);



