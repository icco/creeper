##
# Database config for relational db.
init = Time.now
connections = {
  :development => "postgres://localhost/creeper",
  :test => "postgres://postgres@localhost/creeper_test",
  :production => ENV['DATABASE_URL']
}

# Setup our logger
ActiveRecord::Base.logger = logger

# Include Active Record class name as root for JSON serialized output.
ActiveRecord::Base.include_root_in_json = true

# Store the full class name (including module namespace) in STI type column.
ActiveRecord::Base.store_full_sti_class = true

# Use ISO 8601 format for JSON serialized times and dates.
ActiveSupport.use_standard_json_time_format = true

# Don't escape HTML entities in JSON, leave that for the #json_escape helper.
# if you're including raw json in an HTML page.
ActiveSupport.escape_html_entities_in_json = false

# Raise exception on mass assignment protection for Active Record models.
ActiveRecord::Base.mass_assignment_sanitizer = :strict

# Log the query plan for queries taking more than this (works
# with SQLite, MySQL, and PostgreSQL).
ActiveRecord::Base.auto_explain_threshold_in_seconds = 0.5

# Include Active Record class name as root for JSON serialized output.
ActiveRecord::Base.include_root_in_json = false

# Store the full class name (including module namespace) in STI type column.
ActiveRecord::Base.store_full_sti_class = true

# Now we can estabilish connection with our db
if connections[Padrino.env]
  url = URI(connections[Padrino.env])
  options = {
    :adapter => url.scheme,
    :host => url.host,
    :port => url.port,
    :database => url.path[1..-1],
    :username => url.user,
    :password => url.password
  }

  case url.scheme
  when "sqlite"
    options[:adapter] = "sqlite3"
    options[:database] = url.host + url.path
  when "postgres"
    options[:adapter] = "postgresql"
    options[:user] = 'postgres' if ENV['TRAVIS'] == true
  end

  # Log what we are connecting to.
  logger.bench "DB", init, "#{options.inspect}", :devel, :green

  ActiveRecord::Base.establish_connection(options)
else
  logger.push("No database configuration for #{Padrino.env.inspect}", :fatal)
end
