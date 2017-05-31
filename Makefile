all:
	gem install bundler
	bundle install --without production
	git init
	git config user.name "Jingnong"
	git config user.email "wangjingnong@hotmail.com"
	git add .
	git commit -m "version"
	heroku git:remote -a myapplication1278
	git push heroku master
