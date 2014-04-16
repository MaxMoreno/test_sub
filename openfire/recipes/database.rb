db = node[:openfire][:database]

return unless db[:active]

case db[:type]

when 'mysql'
	if db[:local]
		# set up the database and user
		include_recipe 'mysql::server'

		conn = {
			:host => '127.0.0.1',
			:port => db[:port],
			:username => 'root',
			:password => node[:mysql][:server_root_password]
		}

		mysql_database_user db[:user] do
			action :create
			connection conn
			password db[:password]
		end

		mysql_database db[:name] do
			action :create
			connection conn
			owner db[:user]
		end
	end

	include_recipe 'database::mysql'

when 'postgresql'
	if db[:local]
		# set up the database and user
		include_recipe 'postgresql::server'

		conn = {
			:host => '127.0.0.1',
			:port => db[:port],
			:username => 'postgres',
			:password => node[:postgresql][:password][:postgres]
		}

		postgresql_database_user db[:user] do
			action :create
			connection conn
			password db[:password]
		end

		postgresql_database db[:name] do
			action :create
			connection conn
			owner db[:user]
		end
	end

	include_recipe 'database::postgresql'

else
	raise "don't know how to handle database #{db[:type]}"
end
