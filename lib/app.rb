# frozen_string_literal: true

require "sinatra"

set :port, 4567

get "/", provides: "html" do
  <<~HTML
    <!DOCTYPE html>
      <html>
        <head>
          <title>Term Deposit Calculator</title>
          <meta charset="UTF-8">
        </head>
        <body>


     <h2>Term Deposit Calculator</h2>

      </body>
    </html>
  HTML
end
