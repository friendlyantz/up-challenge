# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(__dir__))
require "sinatra"
require 'handlers/input_handler'

set :port, 4567

get "/", provides: "html" do
  <<~HTML
    <!DOCTYPE html>
      <html>
        <head>
        <script src="htmx/htmx.min.js"></script>
          <title>Term Deposit Calculator</title>
          <meta charset="UTF-8">
        </head>
        <body>


     <h2>Term Deposit Calculator</h2>

     <button hx-get="/cash_form" hx-target="#cash_form" hx-swap="innerHTML">
       Cash
     </button>

     <button hx-get="/term_form"  hx-target="#cash_form" hx-swap="innerHTML">
       TermDeposit
     </button>

    <form  hx-post="/calculate" hx-target="#result" hx-swap="innerHTML>

       <label for="principal">Starting with (Principal):</label>
       <input type="text" id="principal" name="principal"
             hx-post="/calculate"
             hx-trigger="change"
             placeholder="10000.00"><br>

       <label for="interest_rate">Interest Rate p.a.:</label>
       <input type="text" id="interest_rate" name="interest_rate"
             hx-post="/calculate"
             hx-trigger="change"
             placeholder="0.12"><br>

       <label for="term">Term in Years:</label>
       <input type="text" id="term" name="term"
             hx-post="/calculate"
             hx-trigger="change"
             placeholder="1.5"><br>

       <div id="cash_form">
         <p style="color: red;"> Please select Cash or TermDeposit </p>
       </div>

       <input type="submit" value="Re-Calculate">
    </form>

        <div id="result">
        <p style="color: red;"> Please fill the form above </p>
        </div>

      </body>
    </html>
  HTML
end

post "/calculate" do
  request = InputHandler.new(request_args: params).handle
  if request[:success]
    <<~RESULT
       <div id="final-balance">
        <h1>Final balance:</h1>
        #{request[:result].final_balance.round.format}
      </div>

      <div id="total-interest">
      <h1>Total interest earned:</h1>
        #{request[:result].final_interest_earned.round.format}
      </div>


      <h1>Monthly Interests:</h1>
      <table id="table" border="2" style="text-align: right;" >
        <tr>
          <th>Period</th>
          <th>Extra deposits</th>
          <th>Interest Rate</th>
          <th>Interest Earned</th>
          <th>Balance</th>
        </tr>
        #{
         request[:result].monthly_interests.map do |e|
           <<~CONTENT
             <tr>
                <td>#{e.name}</td>
                <td>#{e.top_up.round.format}</td>
                <td>#{format('%.2f%%', e.rate * 100)}</td>
                <td>#{e.interest_earned.round.format}</td>
                <td>#{e.balance.round.format}</td>
             </tr>
           CONTENT
         end.join
       }
      </table>
    RESULT
  else
    <<~ERRORS
      <ul style="color: red;">
         #{
            request[:errors].map do |error|
              <<~CONTENT
                <li>#{error}</li>
              CONTENT
            end.join
          }
      </ul>
    ERRORS
  end
end

def compounting_freq_picker(period_name)
  <<~HTML
    <input type="radio" id="#{period_name}" name="compounding" value="#{period_name}"
          hx-post="/calculate" hx-trigger="change" >
    <label for="#{period_name}">#{period_name}</label>
  HTML
end

get "/cash_form" do
  extra_deposit_form = <<~HTML
    <label for="top_up">Extra deposit:</label>
    <input type="text" id="top_up" name="top_up" hx-post="/calculate" hx-trigger="change" placeholder="0.00" >
    <div> Extra deposit every: </div>
  HTML

  extra_deposit_form +
    compounting_freq_picker("Weekly") +
    compounting_freq_picker("Fortnightly") +
    compounting_freq_picker("Monthly") +
    compounting_freq_picker("Annually")
end

get "/term_form" do
  "Interest paid:<br>" +
    compounting_freq_picker("Monthly") +
    compounting_freq_picker("Quarterly") +
    compounting_freq_picker("Annually") +
    compounting_freq_picker("Maturity")
end
