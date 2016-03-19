module Analyzable
  def average_price(product_list)
  	average_price = 0
  	sum = 0

  	product_list.each do |product|
  		val = product.price.to_f
  		sum += val.round(2)
  	end
  	
  	rounded_sum = sum.round(2)
  	average_price = (rounded_sum/product_list.length).round(2)
  end
end
