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

  def print_report(product_list)
  	report = ""

  	report += get_average_price_report(product_list)
  	report += get_inventory_by_brand_report(product_list)
  	report += get_inventory_by_name_report(product_list)
  	
  	return report
  end

  def get_average_price_report(product_list)
  	average_price = average_price(product_list)
  	"Average Price: $" + average_price.to_s + "\n"
  end

  def get_inventory_by_brand_report(product_list)
  	report_details = "Inventory by Brand:\n"
  	brands = product_list.group_by {|i| i.brand}
  	
  	brands.each do |key, value|
  	report_details += "- #{key}: #{value.length}\n"
  	end

  	return report_details
  end

  def get_inventory_by_name_report(product_list)
  	report_details = "Inventory by Name:\n"
  	brands = product_list.group_by {|i| i.name}
  	
  	brands.each do |key, value|
  	report_details += "- #{key}: #{value.length}\n"
  	end

  	return report_details
  end
end
