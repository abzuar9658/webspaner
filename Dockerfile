FROM ruby:3.0.5

WORKDIR /app

COPY Gemfile Gemfile.lock /app/

RUN gem install bundler
RUN bundle install

COPY . /app/

CMD ["ruby", "main.rb", "http://www.google.com", "http://www.wikipedia.com"]
