# TODO

# We use Golang version 1.15.14 for the build, with the 
# environment variable CGO_ENABLED set to 0.

# Run the build scripts:
#  - src/stock-api/restore.sh
#  - src/stock-api/build.sh
#  you'll need to make the files executable first with chmod +x <filename>.

# Build output is a single executable file:
#  /server

# The app should run on a minimal OS.

# We need to set four environment variables - 
# GOLANG_VERSION and APP_VERSION - expected by ops
# CACHE_EXPIRY_SECONDS set to 45
# POSTGRES_CONNECTION_STRING set to "host=products-db port=5432 user=postgres password=widgetario dbname=postgres sslmode=disable"

# The startup command needs to run the executable from the build:
#  /server

# We also need to create an empty directory at /cache.
