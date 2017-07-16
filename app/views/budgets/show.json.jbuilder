# json.array! @transactions.each do |transaction|
#   json.date transaction['date']
#   json.description transaction['name']
#   json.category transaction['category']
#   json.amount transaction['amount']
# end

json.response @auth_response
