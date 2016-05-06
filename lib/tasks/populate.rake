namespace :db do
	desc "Generate users"
	task populate: :environment do
		# 產生fixed users:FackA FackB
		FackA = User.create!(name: "FSc" ,email: "FackScHaung@Nctu.edu.tw", password:"FSc",password_confirmation: "FSc")
		FackB = User.create!(name: "FWc" ,email: "FackWcWang@Nctu.edu.tw", password:"FWc",password_confirmation: "FWc")

		#產生98個隨機使用者
		users = [FackA,FackB]
		users += 98.times.collect do |i|
			name = "#{Facker::Name.first_name}#{i}"
			email = "#{name}@example.com"
			password = Facker::Internet.password
			user = User.create!(name: name ,email: email, password: password,password_confirmation: password)
		end

		#亂數(Randomize)產生使用者的建立時間 - Randomize user created_at timestamp
		users.each { |user| user.update!(create_at: Date.today - rand(30)) }

		#產生PO文(posts)
		posts = (10*users.count).times.collect do
			users.sample.posts.create!(content: Facker::Lorem.sentence)
		end

		#產生關注的人(followings) (自動產生關注關係)
		followings = (5*users.count).times.collect do
			from = users.sample
			to = users.sample
			from.follow(to) unless from == to || from.following?(to)
		end
	end
end