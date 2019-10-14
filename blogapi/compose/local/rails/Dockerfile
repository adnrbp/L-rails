FROM ruby:latest

# 1-Define Home
ENV APP_HOME /app

# 2-Install OS Dependencies
RUN apt-get update \
	&& apt-get install -y build-essential \
	# for postgres
	&& apt-get install -y libpq-dev --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

# 3-Change working directory
WORKDIR $APP_HOME

# 4-Install APP Dependencies
COPY Gemfile* $APP_HOME/
RUN bundle install

# 5-Copy Start Script
COPY ./compose/local/rails/start /start
RUN sed -i 's/\r//' /start
RUN chmod +x /start

# 7-Port
EXPOSE 8002
